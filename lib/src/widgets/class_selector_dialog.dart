import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ntut_api_service.dart';
import '../l10n/app_localizations.dart';

/// 班級/學程選擇器對話框
/// 整合三種查詢方式：
/// 1. 班級選擇（學院 → 系所 → 班級）
/// 2. 微學程查詢
/// 3. 學程查詢（未來擴展）
class ClassSelectorDialog extends StatefulWidget {
  final String year;
  final String semester;
  final Function(List<Map<String, dynamic>> courses, String title) onCoursesSelected;

  const ClassSelectorDialog({
    super.key,
    required this.year,
    required this.semester,
    required this.onCoursesSelected,
  });

  @override
  State<ClassSelectorDialog> createState() => _ClassSelectorDialogState();
}

class _ClassSelectorDialogState extends State<ClassSelectorDialog> {
  int _selectedTabIndex = 0; // 0: 班級, 1: 學程/微學程
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 標題
            Row(
              children: [
                Text(
                  l10n.selectClassOrProgramTitle,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Tab 選擇
            ToggleButtons(
              isSelected: [_selectedTabIndex == 0, _selectedTabIndex == 1],
              onPressed: (index) {
                setState(() => _selectedTabIndex = index);
              },
              borderRadius: BorderRadius.circular(8),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(l10n.classCategory),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(l10n.microProgram),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 內容區域
            Expanded(
              child: _selectedTabIndex == 0
                  ? _ClassSelector(
                      year: widget.year,
                      semester: widget.semester,
                      onCoursesSelected: widget.onCoursesSelected,
                    )
                  : _ProgramSelector(
                      year: widget.year,
                      semester: widget.semester,
                      onCoursesSelected: widget.onCoursesSelected,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 班級選擇器（學院 → 系所 → 班級）
class _ClassSelector extends StatefulWidget {
  final String year;
  final String semester;
  final Function(List<Map<String, dynamic>> courses, String title) onCoursesSelected;

  const _ClassSelector({
    required this.year,
    required this.semester,
    required this.onCoursesSelected,
  });

  @override
  State<_ClassSelector> createState() => _ClassSelectorState();
}

class _ClassSelectorState extends State<_ClassSelector> {
  bool _isLoading = true;
  List<dynamic> _colleges = []; // 學院列表
  String? _selectedCollege; // 選中的學院
  List<dynamic> _departments = []; // 當前學院的系所列表
  String? _selectedDepartment; // 選中的系所
  List<dynamic> _grades = []; // 當前系所的班級列表

  @override
  void initState() {
    super.initState();
    _loadColleges();
  }

  Future<void> _loadColleges() async {
    setState(() => _isLoading = true);
    
    try {
      final api = context.read<NtutApiService>();
      final structure = await api.getColleges(
        year: widget.year,
        semester: widget.semester,
      );
      
      debugPrint('[ClassSelector] 載入學院結構');
      
      if (structure != null && structure['colleges'] != null) {
        setState(() {
          _colleges = structure['colleges'] as List;
          _isLoading = false;
        });
        debugPrint('[ClassSelector] 載入 ${_colleges.length} 個學院');
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.loadCollegeStructureFailed),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[ClassSelector] 載入學院結構失敗: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorWithValue(e.toString()))),
        );
      }
    }
  }

  void _onCollegeSelected(String collegeName) {
    final college = _colleges.firstWhere(
      (c) => c['name'] == collegeName,
      orElse: () => null,
    );
    
    if (college != null && college['departments'] != null) {
      setState(() {
        _selectedCollege = collegeName;
        _departments = college['departments'] as List;
        _selectedDepartment = null;
        _grades = [];
      });
    }
  }

  void _onDepartmentSelected(String departmentName) {
    final dept = _departments.firstWhere(
      (d) => d['name'] == departmentName,
      orElse: () => null,
    );
    
    if (dept != null && dept['grades'] != null) {
      setState(() {
        _selectedDepartment = departmentName;
        _grades = dept['grades'] as List;
      });
    }
  }

  Future<void> _loadCoursesByGrade(String gradeCode, String gradeName) async {
    setState(() => _isLoading = true);
    
    try {
      final api = context.read<NtutApiService>();
      final courses = await api.getCoursesByGrade(
        gradeCode: gradeCode,
        year: widget.year,
        semester: widget.semester,
      );
      
      setState(() => _isLoading = false);
      
      if (courses.isNotEmpty) {
        widget.onCoursesSelected(courses, gradeName);
        Navigator.of(context).pop();
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noCourseData2(gradeName))),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loadCourseFailedWithError(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 學院下拉選單
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: l10n.college,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          value: _selectedCollege,
          hint: Text(l10n.pleaseSelectCollege),
          items: _colleges.map((college) {
            final collegeName = college['name']?.toString() ?? '';
            return DropdownMenuItem<String>(
              value: collegeName,
              child: Text(collegeName),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _onCollegeSelected(value);
            }
          },
        ),
        const SizedBox(height: 16),
        
        // 系所下拉選單
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: l10n.departmentOrProgram,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          value: _selectedDepartment,
          hint: Text(l10n.pleaseSelectCollegeFirst),
          items: _departments.map((dept) {
            final deptName = dept['name']?.toString() ?? '';
            return DropdownMenuItem<String>(
              value: deptName,
              child: Text(deptName),
            );
          }).toList(),
          onChanged: _selectedCollege == null
              ? null
              : (value) {
                  if (value != null) {
                    _onDepartmentSelected(value);
                  }
                },
        ),
        const SizedBox(height: 16),
        
        // 班級列表（保持列表形式，因為可能有很多班級）
        Expanded(
          child: _selectedDepartment == null
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      l10n.pleaseSelectCollegeFirst,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: _grades.length,
                    itemBuilder: (context, index) {
                      final grade = _grades[index];
                      final gradeName = grade['name']?.toString() ?? '';
                      final gradeId = grade['id']?.toString() ?? '';
                      
                      return ListTile(
                        title: Text(gradeName),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _loadCoursesByGrade(gradeId, gradeName),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

/// 學程/微學程選擇器
class _ProgramSelector extends StatefulWidget {
  final String year;
  final String semester;
  final Function(List<Map<String, dynamic>> courses, String title) onCoursesSelected;

  const _ProgramSelector({
    required this.year,
    required this.semester,
    required this.onCoursesSelected,
  });

  @override
  State<_ProgramSelector> createState() => _ProgramSelectorState();
}

class _ProgramSelectorState extends State<_ProgramSelector> {
  bool _isLoading = true;
  List<dynamic> _programs = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    debugPrint('[ClassSelector] _ProgramSelector initState 被調用');
    _loadPrograms();
  }

  Future<void> _loadPrograms() async {
    debugPrint('[ClassSelector] _loadPrograms 開始執行');
    setState(() => _isLoading = true);
    
    try {
      final api = context.read<NtutApiService>();
      debugPrint('[ClassSelector] 準備調用 api.getPrograms');
      
      final structure = await api.getPrograms(
        year: widget.year,
        semester: widget.semester,
      );
      
      debugPrint('[ClassSelector] 載入學程結構完成');
      debugPrint('[ClassSelector] structure = $structure');
      debugPrint('[ClassSelector] structure type = ${structure?.runtimeType}');
      
      if (structure != null) {
        debugPrint('[ClassSelector] structure keys = ${structure.keys}');
        debugPrint('[ClassSelector] structure[programs] = ${structure['programs']}');
      }
      
      if (structure != null && structure['programs'] != null) {
        final programs = structure['programs'] as List;
        setState(() {
          _programs = programs;
          _isLoading = false;
        });
        debugPrint('[ClassSelector] 載入 ${_programs.length} 個微學程');
      } else {
        debugPrint('[ClassSelector] structure 為空或沒有 programs 鍵');
        setState(() => _isLoading = false);
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.loadMicroProgramsFailed),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('[ClassSelector] 載入微學程失敗: $e');
      debugPrint('[ClassSelector] Stack trace: $stackTrace');
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorWithValue(e.toString()))),
        );
      }
    }
  }

  Future<void> _loadCoursesByProgram(String programCode, String programName) async {
    setState(() => _isLoading = true);
    
    try {
      final api = context.read<NtutApiService>();
      final courses = await api.getCoursesByProgram(
        programCode: programCode,
        type: 'micro-program', // 目前都是微學程
        year: widget.year,
        semester: widget.semester,
      );
      
      setState(() => _isLoading = false);
      
      if (courses.isNotEmpty) {
        widget.onCoursesSelected(courses, programName);
        Navigator.of(context).pop();
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noCourseData2(programName))),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loadCourseFailedWithError(e.toString()))),
        );
      }
    }
  }

  List<dynamic> get _filteredPrograms {
    if (_searchQuery.isEmpty) return _programs;
    return _programs.where((p) {
      final name = p['name']?.toString().toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // 搜尋框
        TextField(
          decoration: InputDecoration(
            hintText: l10n.searchProgramName,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        const SizedBox(height: 16),
        
        // 學程列表
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: _filteredPrograms.length,
              itemBuilder: (context, index) {
                final program = _filteredPrograms[index];
                final programName = program['name']?.toString() ?? '';
                final programId = program['id']?.toString() ?? '';
                final courseCount = (program['course'] as List?)?.length ?? 0;
                
                return ListTile(
                  title: Text(programName),
                  subtitle: Text(l10n.coursesCount(courseCount)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _loadCoursesByProgram(programId, programName),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
