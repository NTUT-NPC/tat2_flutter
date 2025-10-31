import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/grade.dart';
import '../utils/language_utils.dart';

/// 課程數據助手 - 處理課程名稱的中英文顯示邏輯
/// 參考 TAT 的實現，根據語言設定返回對應的課程名稱
class CourseDataHelper {
  /// 特殊課程的手動翻譯對照表
  /// 用於處理系統中沒有提供英文名稱的特殊課程（如班週會、導師時間等）
  static const Map<String, String> _specialCourseTranslations = {
    '班週會及導師時間': 'Class Meeting',
  };

  /// 從課程 Map 中獲取本地化的課程名稱
  /// [context] 用於獲取當前語言設定
  /// [courseData] 課程數據 Map
  static String getLocalizedCourseName(BuildContext context, Map<String, dynamic> courseData) {
    final languageCode = LanguageUtils.getLanguageCode(context);
    
    if (languageCode == 'en') {
      // 英文模式：優先使用英文名稱
      final nameEn = courseData['courseNameEn'] ?? courseData['course_name_en'];
      if (nameEn != null && nameEn.toString().isNotEmpty) {
        return nameEn.toString();
      }
      
      // 如果沒有英文名稱，檢查是否為特殊課程，使用手動翻譯
      final nameZh = courseData['courseNameZh'] ?? courseData['course_name_zh'] ?? courseData['courseName'];
      if (nameZh != null) {
        final zhName = nameZh.toString();
        if (_specialCourseTranslations.containsKey(zhName)) {
          return _specialCourseTranslations[zhName]!;
        }
      }
    }
    
    // 中文模式或英文名稱不存在：使用中文名稱
    final nameZh = courseData['courseNameZh'] ?? courseData['course_name_zh'];
    if (nameZh != null && nameZh.toString().isNotEmpty) {
      return nameZh.toString();
    }
    
    // 後備：使用 courseName 欄位
    final courseName = courseData['courseName'] ?? courseData['course_name'] ?? '';
    return courseName.toString();
  }
  
  /// 從 Course 模型獲取本地化的課程名稱
  static String getCourseLocalizedName(BuildContext context, Course course) {
    final languageCode = LanguageUtils.getLanguageCode(context);
    final localizedName = course.getLocalizedName(languageCode);
    
    // 如果是英文模式且沒有英文名稱，檢查是否為特殊課程
    if (languageCode == 'en' && localizedName == course.courseName) {
      final zhName = course.courseNameZh ?? course.courseName;
      if (_specialCourseTranslations.containsKey(zhName)) {
        return _specialCourseTranslations[zhName]!;
      }
    }
    
    return localizedName;
  }
  
  /// 從 Grade 模型獲取本地化的課程名稱
  static String getGradeLocalizedName(BuildContext context, Grade grade) {
    final languageCode = LanguageUtils.getLanguageCode(context);
    final localizedName = grade.getLocalizedName(languageCode);
    
    // 如果是英文模式且沒有英文名稱，檢查是否為特殊課程
    if (languageCode == 'en' && localizedName == grade.courseName) {
      final zhName = grade.courseNameZh ?? grade.courseName;
      if (_specialCourseTranslations.containsKey(zhName)) {
        return _specialCourseTranslations[zhName]!;
      }
    }
    
    return localizedName;
  }
  
  /// 合併中英文課程數據
  /// 當同一課程的中文和英文資料都取得時，將它們合併為一個完整的課程對象
  static Map<String, dynamic> mergeCourseData({
    required Map<String, dynamic> zhData,
    Map<String, dynamic>? enData,
  }) {
    final merged = Map<String, dynamic>.from(zhData);
    
    // 如果沒有英文數據，直接返回中文數據
    if (enData == null) {
      // 確保 courseNameZh 有值
      if (!merged.containsKey('courseNameZh') && merged.containsKey('courseName')) {
        merged['courseNameZh'] = merged['courseName'];
      }
      return merged;
    }
    
    // 合併英文課程名稱
    merged['courseNameEn'] = enData['courseName'] ?? enData['course_name'] ?? '';
    
    // 確保 courseNameZh 有值
    if (!merged.containsKey('courseNameZh') && merged.containsKey('courseName')) {
      merged['courseNameZh'] = merged['courseName'];
    }
    
    return merged;
  }
  
  /// 合併中英文成績數據
  static Map<String, dynamic> mergeGradeData({
    required Map<String, dynamic> zhData,
    Map<String, dynamic>? enData,
  }) {
    final merged = Map<String, dynamic>.from(zhData);
    
    // 如果沒有英文數據，直接返回中文數據
    if (enData == null) {
      // 確保 courseNameZh 有值
      if (!merged.containsKey('courseNameZh') && merged.containsKey('courseName')) {
        merged['courseNameZh'] = merged['courseName'];
      }
      return merged;
    }
    
    // 合併英文課程名稱
    merged['courseNameEn'] = enData['courseName'] ?? enData['course_name'] ?? '';
    
    // 確保 courseNameZh 有值
    if (!merged.containsKey('courseNameZh') && merged.containsKey('courseName')) {
      merged['courseNameZh'] = merged['courseName'];
    }
    
    return merged;
  }
  
  /// 根據課號匹配中英文課程
  /// 返回合併後的課程列表
  static List<Map<String, dynamic>> matchAndMergeCourses({
    required List<Map<String, dynamic>> zhCourses,
    required List<Map<String, dynamic>> enCourses,
  }) {
    final merged = <Map<String, dynamic>>[];
    
    // 建立英文課程的 courseId 映射
    final enCoursesMap = <String, Map<String, dynamic>>{};
    for (final enCourse in enCourses) {
      final courseId = enCourse['courseId'] ?? enCourse['course_id'] ?? '';
      if (courseId.isNotEmpty) {
        enCoursesMap[courseId] = enCourse;
      }
    }
    
    // 遍歷中文課程，尋找對應的英文課程並合併
    for (final zhCourse in zhCourses) {
      final courseId = zhCourse['courseId'] ?? zhCourse['course_id'] ?? '';
      final enCourse = courseId.isNotEmpty ? enCoursesMap[courseId] : null;
      
      merged.add(mergeCourseData(
        zhData: zhCourse,
        enData: enCourse,
      ));
    }
    
    return merged;
  }
  
  /// 根據課號匹配中英文成績
  /// 返回合併後的成績列表
  static List<Map<String, dynamic>> matchAndMergeGrades({
    required List<Map<String, dynamic>> zhGrades,
    required List<Map<String, dynamic>> enGrades,
  }) {
    final merged = <Map<String, dynamic>>[];
    
    // 建立英文成績的 courseId 映射
    final enGradesMap = <String, Map<String, dynamic>>{};
    for (final enGrade in enGrades) {
      final courseId = enGrade['courseId'] ?? enGrade['course_id'] ?? '';
      if (courseId.isNotEmpty) {
        enGradesMap[courseId] = enGrade;
      }
    }
    
    // 遍歷中文成績，尋找對應的英文成績並合併
    for (final zhGrade in zhGrades) {
      final courseId = zhGrade['courseId'] ?? zhGrade['course_id'] ?? '';
      final enGrade = courseId.isNotEmpty ? enGradesMap[courseId] : null;
      
      merged.add(mergeGradeData(
        zhData: zhGrade,
        enData: enGrade,
      ));
    }
    
    return merged;
  }
}
