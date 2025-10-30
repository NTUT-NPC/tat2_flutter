import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../l10n/app_localizations.dart';
import '../services/ischool_plus_service.dart';
import '../services/ntut_api_service.dart';
import '../services/ischool_plus_cache_service.dart';
import '../services/badge_service.dart';
import '../widgets/login_required_view.dart';
import 'ischool_plus/announcement_list_page.dart';
import 'ischool_plus/course_files_page.dart';

/// 北科i學園頁面
class NtutLearnPage extends StatefulWidget {
  const NtutLearnPage({super.key});

  @override
  State<NtutLearnPage> createState() => _NtutLearnPageState();
}

class _NtutLearnPageState extends State<NtutLearnPage> {
  bool _isLoggingIn = false;
  bool _isLoggedIn = false;
  bool _isInitialized = false;
  bool _isLoadingCourses = false;
  final bool _isSyncing = false; // 防止重複同步
  
  // 從課表取得的課程列表
  List<Map<String, dynamic>> _courses = [];

  @override
  void initState() {
    super.initState();
    // 監聽 BadgeService 變化
    BadgeService().addListener(_onBadgeChanged);
    _initializeService();
  }

  @override
  void dispose() {
    BadgeService().removeListener(_onBadgeChanged);
    super.dispose();
  }

  void _onBadgeChanged() {
    if (mounted) {
      setState(() {}); // 紅點狀態改變時重新整理
    }
  }

  void _initializeService() async {
    // 從 Provider 取得 NtutApiService 並初始化 ISchoolPlusService
    final ntutApiService = context.read<NtutApiService>();
    ISchoolPlusService.initialize(ntutApiService);
    setState(() {
      _isInitialized = true;
    });
    _loadCourses();
    // 自動開始登入流程
    await _login();
  }
  
  Future<void> _loadCourses() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingCourses = true;
    });

    try {
      // 取得當前學期
      final now = DateTime.now();
      final year = now.year - 1911; // 轉換為民國年
      final semester = now.month >= 2 && now.month <= 7 ? 2 : 1; // 2-7月為第二學期，其他為第一學期
      
      // 只從緩存中讀取課表，不發起網路請求
      List<Map<String, dynamic>> courses = [];
      try {
        final cacheBox = await Hive.openBox('course_table_cache');
        final cacheKey = 'courses_${year}_$semester';
        final cachedData = cacheBox.get(cacheKey);
        
        if (cachedData != null && cachedData is List) {
          courses = (cachedData).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          print('[NtutLearn] 從緩存獲取課表成功，共 ${courses.length} 門課程');
        } else {
          print('[NtutLearn] 緩存中沒有課表數據（需要用戶先進入課表頁面）');
        }
      } catch (e) {
        print('[NtutLearn] 從緩存獲取課表失敗: $e');
      }
      
      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoadingCourses = false;
        });
      }
    } catch (e) {
      print('[NtutLearn] Failed to load courses: $e');
      if (mounted) {
        setState(() {
          _isLoadingCourses = false;
        });
      }
    }
  }

  void _checkLoginStatus() {
    if (!_isInitialized) return;
    final service = ISchoolPlusService.instance;
    setState(() {
      _isLoggedIn = service.isLoggedIn;
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      final service = ISchoolPlusService.instance;
      final success = await service.login();

      if (mounted) {
        setState(() {
          _isLoggedIn = success;
          _isLoggingIn = false;
        });
        // 登入失敗時不顯示 SnackBar，用戶會看到登入按鈕
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
        // 登入異常時也不顯示 SnackBar
      }
    }
  }

  /// 顯示清除快取對話框
  void _showClearCacheDialog() async {
    final l10n = AppLocalizations.of(context);
    final cacheService = ISchoolPlusCacheService();
    
    // 計算大小
    final cacheSize = await cacheService.getCacheSize();
    final downloadSize = await cacheService.getDownloadSize();
    final totalSize = cacheSize + downloadSize;
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearISchoolData),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.thisWillClear),
            const SizedBox(height: 8),
            Text('• ${l10n.announcementCache(ISchoolPlusCacheService.formatSize(cacheSize))}'),
            Text('• ${l10n.downloadFiles(ISchoolPlusCacheService.formatSize(downloadSize))}'),
            const SizedBox(height: 8),
            Text(
              l10n.total(ISchoolPlusCacheService.formatSize(totalSize)),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.cannotUndo,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearAllData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.clear),
          ),
        ],
      ),
    );
  }

  /// 清除所有資料
  Future<void> _clearAllData() async {
    final l10n = AppLocalizations.of(context);
    try {
      final cacheService = ISchoolPlusCacheService();
      
      // 顯示進度對話框
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(l10n.clearing),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      
      // 清除快取、檔案和紅點標記
      await cacheService.clearAllCache();
      await cacheService.clearAllDownloads();
      await BadgeService().clearAllISchoolBadges();
      
      if (mounted) {
        Navigator.pop(context); // 關閉進度對話框
        
        // 強制重新整理頁面
        setState(() {});
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.allISchoolDataCleared),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // 關閉進度對話框
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.clearFailedWithError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 清除所有紅點
  Future<void> _clearAllBadges() async {
    final l10n = AppLocalizations.of(context);
    try {
      await BadgeService().clearAllISchoolBadges();
      
      if (mounted) {
        setState(() {}); // 重新整理以更新紅點顯示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.allISchoolBadgesCleared),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.clearBadgesFailedWithError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // 等待初始化完成
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.ntutLearn)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ntutLearn),
        actions: [
          if (_isLoggedIn)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                switch (value) {
                  case 'clear_cache':
                    _showClearCacheDialog();
                    break;
                  case 'clear_badges':
                    await _clearAllBadges();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'clear_cache',
                  child: Text(l10n.clearCacheAndFiles),
                ),
                PopupMenuItem(
                  value: 'clear_badges',
                  child: Text(l10n.markAllAsRead),
                ),
              ],
            ),
        ],
      ),
      body: _isLoggingIn
          ? const Center(child: CircularProgressIndicator())
          : !_isLoggedIn
              ? _buildLoginPrompt()
              : _buildCourseList(),
    );
  }

  Widget _buildLoginPrompt() {
    final l10n = AppLocalizations.of(context);
    return LoginRequiredView(
      featureName: l10n.ntutLearn,
      description: l10n.iSchoolLoginDesc,
      onLoginTap: () async {
        final result = await Navigator.of(context).pushNamed('/login');
        if (result == true && mounted) {
          _login();
        }
      },
    );
  }

  Widget _buildCourseList() {
    final l10n = AppLocalizations.of(context);
    if (_isLoadingCourses) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.loadingCourses),
          ],
        ),
      );
    }

    if (_courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(l10n.noCoursesFound),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _loadCourses,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.reloadCourses),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
        final courseName = course['courseName'] as String? ?? '未知課程';
        final courseId = course['courseId'] as String? ?? '';
        
        // 如果沒有 courseId 或是 NO_ID 開頭（班會課等特殊課程），跳過這個課程
        if (courseId.isEmpty || courseId.startsWith('NO_ID')) {
          return const SizedBox.shrink();
        }

        return _buildCourseCard(courseId, courseName);
      },
    );
  }

  /// 建立課程卡片
  Widget _buildCourseCard(String courseId, String courseName) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: FutureBuilder<bool>(
        future: BadgeService().hasCourseUnreadAnnouncements(courseId),
        builder: (context, courseSnapshot) {
          final hasUnread = courseSnapshot.data ?? false;
          return Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.class_, color: Colors.blue),
                  if (hasUnread)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                courseName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${AppLocalizations.of(context).courseId}：$courseId'),
              children: [
                _buildAnnouncementTile(courseId, courseName),
                _buildMaterialTile(courseId, courseName),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 建立公告列表項
  Widget _buildAnnouncementTile(String courseId, String courseName) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<bool>(
      future: BadgeService().hasCourseUnreadAnnouncements(courseId),
      builder: (context, snapshot) {
        final hasUnread = snapshot.data ?? false;
        return ListTile(
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications, color: Colors.orange),
              if (hasUnread)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          title: Text(l10n.courseAnnouncements),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnnouncementListPage(
                  courseId: courseId,
                  courseName: courseName,
                ),
              ),
            ).then((_) {
              // 返回時重新整理以更新紅點狀態
              if (mounted) setState(() {});
            });
          },
        );
      },
    );
  }

  /// 建立教材列表項
  Widget _buildMaterialTile(String courseId, String courseName) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(Icons.folder, color: Colors.green),
      title: Text(l10n.courseMaterials),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseFilesPage(
              courseId: courseId,
              courseName: courseName,
            ),
          ),
        );
      },
    );
  }
}
