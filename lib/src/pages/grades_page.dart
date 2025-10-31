import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/grade.dart';
import '../models/semester_grade_stats.dart';
import '../services/grades_service.dart';
import '../services/ntut_api_service.dart';
import '../services/auth_service.dart';
import '../providers/auth_provider_v2.dart';
import '../widgets/grade_item_widget.dart';
import '../widgets/grade_summary_widget.dart';
import '../widgets/semester_stats_widget.dart';
import '../widgets/login_required_view.dart';

/// 成績查詢頁面
class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late GradesService _gradesService;
  
  Map<String, List<Grade>> _gradesBySemester = {};
  Map<String, SemesterGradeStats> _semesterStats = {};
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    // 延遲初始化和載入，等待 context 可用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGrades();
    });
  }

  Future<void> _loadGrades({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProviderV2>();
      final authService = context.read<AuthService>();
      
      // 先從 AuthService 獲取保存的憑證
      final credentials = await authService.getSavedCredentials();
      
      // 如果沒有保存的憑證，顯示登入提示
      if (credentials == null) {
        setState(() {
          _errorMessage = 'needLogin';
          _isLoading = false;
        });
        return;
      }
      
      final studentId = credentials['studentId'];
      
      if (studentId == null || studentId.isEmpty) {
        setState(() {
          _errorMessage = 'cannotGetStudentId';
          _isLoading = false;
        });
        return;
      }
      
      // 檢查是否已登入（如果已登入就不需要再次嘗試）
      if (!authProvider.isLoggedIn) {
        debugPrint('[GradesPage] 未登入，嘗試自動登入...');
        // 嘗試自動登入
        final loginSuccess = await authProvider.tryAutoLogin();
        
        if (!loginSuccess) {
          debugPrint('[GradesPage] 自動登入失敗');
          setState(() {
            _errorMessage = 'needLogin';
            _isLoading = false;
          });
          return;
        }
        debugPrint('[GradesPage] 自動登入成功');
      }
      
      // 使用 Provider 中的共享實例
      final ntutApi = context.read<NtutApiService>();
      _gradesService = GradesService(
        ntutApi: ntutApi,
      );

      // 從緩存或 NTUT API 獲取成績
      final grades = await _gradesService.getGrades(
        studentId: studentId,
        forceRefresh: forceRefresh, // 根據參數決定是否強制刷新
      );

      if (grades.isEmpty) {
        setState(() {
          _errorMessage = 'noGradeData';
          _isLoading = false;
        });
        return;
      }

      // 按學期分組
      final grouped = _gradesService.groupBySemester(grades);
      
      // 3. 獲取學期統計信息（包含排名）
      final stats = await _gradesService.getSemesterStatsWithRanks(
        studentId: studentId,
        forceRefresh: forceRefresh,
      );

      setState(() {
        _gradesBySemester = grouped;
        _semesterStats = stats;
        _isLoading = false;
        
        // 更新 TabController
        _tabController.dispose();
        _tabController = TabController(
          length: grouped.keys.length + 1, // +1 for 整體統計
          vsync: this,
        );
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'loadGradesFailed:$e';
        _isLoading = false;
      });
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.grades),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.grades),
        ),
        body: LoginRequiredView(
          featureName: l10n.gradesFeatureName,
          description: l10n.gradesLoginDesc,
          onLoginTap: () async {
            final result = await Navigator.of(context).pushNamed('/login');
            if (result == true && mounted) {
              _loadGrades();
            }
          },
        ),
      );
    }

    if (_gradesBySemester.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.grades),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 64, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(l10n.noGradeData),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loadGrades(forceRefresh: true),
                child: Text(l10n.reload),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.grades),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadGrades(forceRefresh: true),
            tooltip: l10n.reload,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          unselectedLabelColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black.withOpacity(0.6)
              : Colors.white.withOpacity(0.6),
          indicatorColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          tabs: [
            Tab(text: l10n.overallStats),
            ..._gradesBySemester.keys.map((semester) => Tab(text: semester)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverallView(),
          ..._gradesBySemester.entries.map(
            (entry) => _buildSemesterView(entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallView() {
    // 計算整體統計
    final allGrades = _gradesBySemester.values.expand((g) => g).toList();
    final overallAverage = _gradesService.calculateWeightedAverage(allGrades);
    final totalCredits = _gradesService.calculateTotalCredits(allGrades);
    
    // 獲取總排名（從 _overall 鍵）
    final overallStats = _semesterStats['_overall'];
    RankInfo? overallClassRank;
    RankInfo? overallDeptRank;
    
    if (overallStats != null) {
      overallClassRank = overallStats.classRank;
      overallDeptRank = overallStats.departmentRank;
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        OverallGradeSummaryWidget(
          overallAverage: overallAverage,
          totalCredits: totalCredits,
          overallClassRank: overallClassRank,
          overallDeptRank: overallDeptRank,
        ),
        
        // 各學期成績列表
        Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context).semesterGradesList,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ..._gradesBySemester.entries.map((entry) {
                final stats = _gradesService.getSemesterStats(entry.value);
                final l10n = AppLocalizations.of(context);
                return ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(entry.key),
                  subtitle: Text(
                    l10n.semesterSummary(
                      stats.averageScoreString,
                      stats.earnedCreditsString,
                      stats.totalCreditsString,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    final index = _gradesBySemester.keys.toList().indexOf(entry.key);
                    _tabController.animateTo(index + 1); // +1 因為第一個是整體統計
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterView(String semester, List<Grade> grades) {
    // 優先使用包含排名的統計信息
    final semesterStats = _semesterStats[semester];

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        // 如果有包含排名的統計信息，使用新的 Widget
        if (semesterStats != null)
          SemesterStatsWidget(
            stats: semesterStats,
            title: semester,
          )
        else
          // 否則使用舊的 Widget
          GradeSummaryWidget(
            stats: _gradesService.getSemesterStats(grades, semester: semester),
            title: semester,
          ),
        
        // 成績列表
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const GradeListHeader(),
              ...grades.map((grade) => GradeItemWidget(grade: grade)),
            ],
          ),
        ),
      ],
    );
  }
}
