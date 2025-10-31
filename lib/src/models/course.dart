/// 課程模型
class Course {
  final String courseId;
  final String courseName;        // 當前顯示的課程名稱（根據語言設定）
  final String? courseNameZh;     // 中文課程名稱
  final String? courseNameEn;     // 英文課程名稱
  final String? instructor;
  final String? location;
  final String? timeSlots;
  final String semester;
  final double? credits;
  final Map<String, dynamic>? extra;

  Course({
    required this.courseId,
    required this.courseName,
    this.courseNameZh,
    this.courseNameEn,
    this.instructor,
    this.location,
    this.timeSlots,
    required this.semester,
    this.credits,
    this.extra,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'] ?? json['course_id'] ?? '',
      courseName: json['courseName'] ?? json['course_name'] ?? '',
      courseNameZh: json['courseNameZh'] ?? json['course_name_zh'],
      courseNameEn: json['courseNameEn'] ?? json['course_name_en'],
      instructor: json['instructor'],
      location: json['location'],
      timeSlots: json['timeSlots'] ?? json['time_slots'],
      semester: json['semester'] ?? '',
      credits: json['credits']?.toDouble(),
      extra: json['courseData'] != null 
          ? Map<String, dynamic>.from(json['courseData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      if (courseNameZh != null) 'courseNameZh': courseNameZh,
      if (courseNameEn != null) 'courseNameEn': courseNameEn,
      'instructor': instructor,
      'location': location,
      'timeSlots': timeSlots,
      'semester': semester,
      'credits': credits,
    };
  }
  
  /// 根據語言代碼獲取課程名稱
  /// [languageCode] 可以是 'zh' 或 'en'
  String getLocalizedName(String languageCode) {
    if (languageCode == 'en' && courseNameEn != null && courseNameEn!.isNotEmpty) {
      return courseNameEn!;
    }
    if (courseNameZh != null && courseNameZh!.isNotEmpty) {
      return courseNameZh!;
    }
    return courseName;
  }

  /// 解析上課時間（例如 "二234" → "週二 10:10-13:00"）
  /// [l10n] 為可選參數，如提供則使用國際化，否則使用繁中預設值
  String getFormattedTime([dynamic l10n]) {
    if (timeSlots == null || timeSlots!.isEmpty) return '時間未定';
    
    // 簡化版，實際需要更複雜的解析
    final weekdayMap = l10n != null ? {
      '一': l10n.monShort, '二': l10n.tueShort, '三': l10n.wedShort, 
      '四': l10n.thuShort, '五': l10n.friShort, '六': l10n.satShort, '日': l10n.sunShort,
    } : {
      '一': '週一', '二': '週二', '三': '週三', 
      '四': '週四', '五': '週五', '六': '週六', '日': '週日',
    };
    
    final firstChar = timeSlots!.substring(0, 1);
    final weekday = weekdayMap[firstChar] ?? '';
    return '$weekday $timeSlots';
  }
  
  /// 向後兼容的 getter (使用繁中預設值)
  String get formattedTime => getFormattedTime();
}
