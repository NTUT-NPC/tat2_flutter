import 'package:flutter/material.dart';

/// 應用程式本地化
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // 通用
  String get appName => _localizedValues[locale.languageCode]?['appName'] ?? 'QAQ 北科生活';
  String get appTitle => _localizedValues[locale.languageCode]?['appTitle'] ?? 'TAT 北科生活';
  String get ok => _localizedValues[locale.languageCode]?['ok'] ?? '確定';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? '取消';
  String get save => _localizedValues[locale.languageCode]?['save'] ?? '儲存';
  String get delete => _localizedValues[locale.languageCode]?['delete'] ?? '刪除';
  String get edit => _localizedValues[locale.languageCode]?['edit'] ?? '編輯';
  String get close => _localizedValues[locale.languageCode]?['close'] ?? '關閉';
  String get search => _localizedValues[locale.languageCode]?['search'] ?? '搜尋';
  String get add => _localizedValues[locale.languageCode]?['add'] ?? '新增';
  String get remove => _localizedValues[locale.languageCode]?['remove'] ?? '移除';
  String get loading => _localizedValues[locale.languageCode]?['loading'] ?? '載入中...';
  String get error => _localizedValues[locale.languageCode]?['error'] ?? '錯誤';
  String get success => _localizedValues[locale.languageCode]?['success'] ?? '成功';
  String get confirm => _localizedValues[locale.languageCode]?['confirm'] ?? '確認';
  
  // 導航
  String get courseTable => _localizedValues[locale.languageCode]?['courseTable'] ?? '課表';
  String get calendar => _localizedValues[locale.languageCode]?['calendar'] ?? '日曆';
  String get courseSearch => _localizedValues[locale.languageCode]?['courseSearch'] ?? '課程查詢';
  String get grades => _localizedValues[locale.languageCode]?['grades'] ?? '成績';
  String get credits => _localizedValues[locale.languageCode]?['credits'] ?? '學分';
  String get campusMap => _localizedValues[locale.languageCode]?['campusMap'] ?? '校園地圖';
  String get emptyClassroom => _localizedValues[locale.languageCode]?['emptyClassroom'] ?? '空教室查詢';
  String get clubAnnouncements => _localizedValues[locale.languageCode]?['clubAnnouncements'] ?? '社團公告';
  String get personalization => _localizedValues[locale.languageCode]?['personalization'] ?? '個人化';
  String get adminSystem => _localizedValues[locale.languageCode]?['adminSystem'] ?? '校務系統';
  String get messages => _localizedValues[locale.languageCode]?['messages'] ?? '訊息';
  String get ntutLearn => _localizedValues[locale.languageCode]?['ntutLearn'] ?? '北科i學園';
  String get foodMap => _localizedValues[locale.languageCode]?['foodMap'] ?? '美食地圖';
  String get other => _localizedValues[locale.languageCode]?['other'] ?? '其他';
  
  // 個人化
  String get themeSettings => _localizedValues[locale.languageCode]?['themeSettings'] ?? '配色設定';
  String get themeMode => _localizedValues[locale.languageCode]?['themeMode'] ?? '主題模式';
  String get language => _localizedValues[locale.languageCode]?['language'] ?? '語言';
  String get followSystem => _localizedValues[locale.languageCode]?['followSystem'] ?? '跟隨系統';
  String get lightMode => _localizedValues[locale.languageCode]?['lightMode'] ?? '淺色模式';
  String get darkMode => _localizedValues[locale.languageCode]?['darkMode'] ?? '深色模式';
  String get courseSettings => _localizedValues[locale.languageCode]?['courseSettings'] ?? '課程設定';
  String get courseColor => _localizedValues[locale.languageCode]?['courseColor'] ?? '課程顏色';
  String get courseColorHint => _localizedValues[locale.languageCode]?['courseColorHint'] ?? '長按課表中的課程即可自訂顏色';
  
  // 個人化介紹彈窗
  String get welcomeToPersonalization => _localizedValues[locale.languageCode]?['welcomeToPersonalization'] ?? '歡迎來到個人化設定';
  String get personalizationIntro => _localizedValues[locale.languageCode]?['personalizationIntro'] ?? '這裡可以自訂 App 的外觀與體驗：';
  String get themeColorOption => _localizedValues[locale.languageCode]?['themeColorOption'] ?? '主題顏色';
  String get themeColorDesc => _localizedValues[locale.languageCode]?['themeColorDesc'] ?? '選擇你喜歡的主題色調';
  String get themeModeOption => _localizedValues[locale.languageCode]?['themeModeOption'] ?? '深淺模式';
  String get themeModeDesc => _localizedValues[locale.languageCode]?['themeModeDesc'] ?? '切換亮色或暗色主題';
  String get languageOption => _localizedValues[locale.languageCode]?['languageOption'] ?? '語言設定';
  String get languageDesc => _localizedValues[locale.languageCode]?['languageDesc'] ?? '支援繁體中文和英文';
  String get courseTableStyleOption => _localizedValues[locale.languageCode]?['courseTableStyleOption'] ?? '課表風格';
  String get courseTableStyleDesc => _localizedValues[locale.languageCode]?['courseTableStyleDesc'] ?? '選擇喜歡的課表顯示方式';
  String get courseColorStyleOption => _localizedValues[locale.languageCode]?['courseColorStyleOption'] ?? '課程配色';
  String get courseColorStyleDesc => _localizedValues[locale.languageCode]?['courseColorStyleDesc'] ?? '自訂課表的配色方案';
  String get longPressCourseTip => _localizedValues[locale.languageCode]?['longPressCourseTip'] ?? '長按課表中的課程可以自訂顏色喔！';
  String get startExploring => _localizedValues[locale.languageCode]?['startExploring'] ?? '開始探索';
  
  // 課表風格
  String get courseTableStyle => _localizedValues[locale.languageCode]?['courseTableStyle'] ?? '課表風格';
  String get selectCourseTableStyle => _localizedValues[locale.languageCode]?['selectCourseTableStyle'] ?? '選擇課表風格';
  String get material3Style => _localizedValues[locale.languageCode]?['material3Style'] ?? 'Material 3 風格';
  String get material3StyleDesc => _localizedValues[locale.languageCode]?['material3StyleDesc'] ?? '懸浮卡片設計，現代化視覺';
  String get classicStyle => _localizedValues[locale.languageCode]?['classicStyle'] ?? '經典風格';
  String get classicStyleDesc => _localizedValues[locale.languageCode]?['classicStyleDesc'] ?? '表格式佈局，緊湊簡潔';
  String get tatStyle => _localizedValues[locale.languageCode]?['tatStyle'] ?? 'TAT 傳統風格';
  String get tatStyleDesc => _localizedValues[locale.languageCode]?['tatStyleDesc'] ?? '緊湊表格，馬卡龍色系';
  String get switchedToMaterial3 => _localizedValues[locale.languageCode]?['switchedToMaterial3'] ?? '已切換至 Material 3 風格課表';
  String get switchedToClassic => _localizedValues[locale.languageCode]?['switchedToClassic'] ?? '已切換至經典風格課表';
  String get switchedToTat => _localizedValues[locale.languageCode]?['switchedToTat'] ?? '已切換至 TAT 傳統風格課表';
  
  // 課程配色
  String get courseColorStyle => _localizedValues[locale.languageCode]?['courseColorStyle'] ?? '課程配色';
  String get selectCourseColorStyle => _localizedValues[locale.languageCode]?['selectCourseColorStyle'] ?? '選擇課程配色';
  String get tatColorStyle => _localizedValues[locale.languageCode]?['tatColorStyle'] ?? 'TAT 配色';
  String get tatColorStyleDesc => _localizedValues[locale.languageCode]?['tatColorStyleDesc'] ?? '柔和的馬卡龍色系';
  String get themeColorStyle => _localizedValues[locale.languageCode]?['themeColorStyle'] ?? '主題配色';
  String get themeColorStyleDesc => _localizedValues[locale.languageCode]?['themeColorStyleDesc'] ?? '根據主題色生成';
  String get rainbowColorStyle => _localizedValues[locale.languageCode]?['rainbowColorStyle'] ?? '彩虹配色';
  String get rainbowColorStyleDesc => _localizedValues[locale.languageCode]?['rainbowColorStyleDesc'] ?? '經典彩虹色系';
  String get switchedToTatColor => _localizedValues[locale.languageCode]?['switchedToTatColor'] ?? '已切換至 TAT 配色';
  String get switchedToThemeColor => _localizedValues[locale.languageCode]?['switchedToThemeColor'] ?? '已切換至主題配色';
  String get switchedToRainbowColor => _localizedValues[locale.languageCode]?['switchedToRainbowColor'] ?? '已切換至彩虹配色';
  
  // 課程顏色說明
  String get courseColorInfo => _localizedValues[locale.languageCode]?['courseColorInfo'] ?? '課程顏色說明';
  String get customYourCourseTable => _localizedValues[locale.languageCode]?['customYourCourseTable'] ?? '訂製屬於你自己的課表';
  String get tatMacaronColor => _localizedValues[locale.languageCode]?['tatMacaronColor'] ?? 'TAT 馬卡龍配色';
  String get tatMacaronColorDesc => _localizedValues[locale.languageCode]?['tatMacaronColorDesc'] ?? '柔和的粉彩色系，提供 13 種精選顏色：';
  String get themeDynamicColor => _localizedValues[locale.languageCode]?['themeDynamicColor'] ?? '主題動態配色';
  String get themeDynamicColorDesc => _localizedValues[locale.languageCode]?['themeDynamicColorDesc'] ?? '根據您的主題色生成 16 種和諧配色：';
  String get rainbowColor => _localizedValues[locale.languageCode]?['rainbowColor'] ?? '彩虹色系配色';
  String get rainbowColorDesc => _localizedValues[locale.languageCode]?['rainbowColorDesc'] ?? '經典的彩虹色譜，提供 16 種鮮明顏色：';
  String get softMacaronTone => _localizedValues[locale.languageCode]?['softMacaronTone'] ?? '柔和的馬卡龍色調';
  String get eyeFriendlyLightColor => _localizedValues[locale.languageCode]?['eyeFriendlyLightColor'] ?? '保護眼睛的淺色系';
  String get highRecognitionColor => _localizedValues[locale.languageCode]?['highRecognitionColor'] ?? '高辨識度的色彩搭配';
  String get blendWithTheme => _localizedValues[locale.languageCode]?['blendWithTheme'] ?? '與主題色完美融合';
  String get warmColdGradient => _localizedValues[locale.languageCode]?['warmColdGradient'] ?? '冷暖色調漸變搭配';
  String get autoAdaptMode => _localizedValues[locale.languageCode]?['autoAdaptMode'] ?? '自動適配亮暗模式';
  String get evenHueDistribution => _localizedValues[locale.languageCode]?['evenHueDistribution'] ?? '色相均勻分布';
  String get maxRecognition => _localizedValues[locale.languageCode]?['maxRecognition'] ?? '最大化辨識度';
  String get independentOfTheme => _localizedValues[locale.languageCode]?['independentOfTheme'] ?? '獨立於主題色';
  String get longPressToCustomColor => _localizedValues[locale.languageCode]?['longPressToCustomColor'] ?? '長按課表中的任一課程\n即可自訂專屬顏色';
  String get gotIt => _localizedValues[locale.languageCode]?['gotIt'] ?? '我知道了';
  
  // 重新分配顏色
  String get reassignColors => _localizedValues[locale.languageCode]?['reassignColors'] ?? '重新隨機分配顏色';
  String get reassignColorsDesc => _localizedValues[locale.languageCode]?['reassignColorsDesc'] ?? '清除所有自訂顏色，重新自動分配';
  String get reassignColorsConfirm => _localizedValues[locale.languageCode]?['reassignColorsConfirm'] ?? '重新隨機分配顏色';
  String get thisWillDo => _localizedValues[locale.languageCode]?['thisWillDo'] ?? '此操作將：';
  String get clearAllCustomColors => _localizedValues[locale.languageCode]?['clearAllCustomColors'] ?? '清除所有自訂顏色';
  String get reassignCourseColors => _localizedValues[locale.languageCode]?['reassignCourseColors'] ?? '重新自動分配課程顏色';
  String useColorSystem(String system) => _localizedValues[locale.languageCode]?['useColorSystem']?.replaceAll('%s', system) ?? '使用 $system';
  String get cannotUndo => _localizedValues[locale.languageCode]?['cannotUndo'] ?? '此操作無法復原';
  String get tatMacaronColorSystem => _localizedValues[locale.languageCode]?['tatMacaronColorSystem'] ?? 'TAT 馬卡龍色系';
  String get themeGradientColorSystem => _localizedValues[locale.languageCode]?['themeGradientColorSystem'] ?? '主題漸變色系';
  String get rainbowColorSystem => _localizedValues[locale.languageCode]?['rainbowColorSystem'] ?? '彩虹色系';
  String reassignedWithSystem(String system) => _localizedValues[locale.languageCode]?['reassignedWithSystem']?.replaceAll('%s', system) ?? '已使用 $system 重新分配課程顏色';
  
  // 設定
  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? '設定';
  String get customNavBar => _localizedValues[locale.languageCode]?['customNavBar'] ?? '自訂導航欄';
  String get customNavBarHint => _localizedValues[locale.languageCode]?['customNavBarHint'] ?? '選擇常用功能顯示在導航欄';
  String get about => _localizedValues[locale.languageCode]?['about'] ?? '關於我們';
  String get aboutHint => _localizedValues[locale.languageCode]?['aboutHint'] ?? '應用程式資訊與版本';
  String get feedback => _localizedValues[locale.languageCode]?['feedback'] ?? '意見反饋';
  String get feedbackHint => _localizedValues[locale.languageCode]?['feedbackHint'] ?? '提供建議或回報問題';
  String get relogin => _localizedValues[locale.languageCode]?['relogin'] ?? '重新登入';
  String get reloginHint => _localizedValues[locale.languageCode]?['reloginHint'] ?? '重新登入學校帳號';
  String get reloginConfirm => _localizedValues[locale.languageCode]?['reloginConfirm'] ?? '將清除當前登入狀態並跳轉到登入頁面';
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? '登出';
  String get logoutConfirm => _localizedValues[locale.languageCode]?['logoutConfirm'] ?? '確定要登出嗎？';
  String get account => _localizedValues[locale.languageCode]?['account'] ?? '帳號';
  
  // 導航配置
  String get navConfigTitle => _localizedValues[locale.languageCode]?['navConfigTitle'] ?? '導航列設定';
  String get customNavBarTitle => _localizedValues[locale.languageCode]?['customNavBarTitle'] ?? '自訂底部導航列';
  String get customNavBarDesc => _localizedValues[locale.languageCode]?['customNavBarDesc'] ?? '點擊項目更換功能，長按可拖曳排序';
  String get selectedCount => _localizedValues[locale.languageCode]?['selectedCount'] ?? '已選擇';
  String get resetToDefault => _localizedValues[locale.languageCode]?['resetToDefault'] ?? '重設為預設';
  String get selectFunction => _localizedValues[locale.languageCode]?['selectFunction'] ?? '選擇功能';
  String get addFunction => _localizedValues[locale.languageCode]?['addFunction'] ?? '選擇要新增的功能';
  String get unsavedChanges => _localizedValues[locale.languageCode]?['unsavedChanges'] ?? '未儲存的變更';
  String get unsavedChangesDesc => _localizedValues[locale.languageCode]?['unsavedChangesDesc'] ?? '您有未儲存的設定，確定要離開嗎？';
  String get leave => _localizedValues[locale.languageCode]?['leave'] ?? '離開';
  String get settingsSaved => _localizedValues[locale.languageCode]?['settingsSaved'] ?? '設定已儲存，重啟 App 後生效';
  
  // 主題對話框
  String get selectThemeMode => _localizedValues[locale.languageCode]?['selectThemeMode'] ?? '選擇主題模式';
  String get followSystemDesc => _localizedValues[locale.languageCode]?['followSystemDesc'] ?? '自動切換淺色/深色模式';
  String get lightModeDesc => _localizedValues[locale.languageCode]?['lightModeDesc'] ?? '使用淺色背景主題';
  String get darkModeDesc => _localizedValues[locale.languageCode]?['darkModeDesc'] ?? '使用深色背景主題';
  
  // 語言對話框
  String get selectLanguage => _localizedValues[locale.languageCode]?['selectLanguage'] ?? '選擇語言';
  String get followSystemLang => _localizedValues[locale.languageCode]?['followSystemLang'] ?? '使用系統預設語言';
  String get traditionalChinese => _localizedValues[locale.languageCode]?['traditionalChinese'] ?? '繁體中文';
  String get english => _localizedValues[locale.languageCode]?['english'] ?? 'English';
  
  // 其他常用文字
  String get system => _localizedValues[locale.languageCode]?['system'] ?? '系統';
  String get otherFeatures => _localizedValues[locale.languageCode]?['otherFeatures'] ?? '更多功能';
  String get confirmLogout => _localizedValues[locale.languageCode]?['confirmLogout'] ?? '確認登出';
  String get maxNavItems => _localizedValues[locale.languageCode]?['maxNavItems'] ?? '最多只能設定 5 個導航項目';
  String get noMoreFunctions => _localizedValues[locale.languageCode]?['noMoreFunctions'] ?? '沒有更多功能可以新增';
  String get minOneNavItem => _localizedValues[locale.languageCode]?['minOneNavItem'] ?? '至少需要保留一個導航項目';
  String get hint => _localizedValues[locale.languageCode]?['hint'] ?? '提示';
  String get position => _localizedValues[locale.languageCode]?['position'] ?? '位置';
  String get fixed => _localizedValues[locale.languageCode]?['fixed'] ?? '固定';
  String get navConfigHint1 => _localizedValues[locale.languageCode]?['navConfigHint1'] ?? '可自訂 1-5 個導航項目，最多 6 個（含「其他」）';
  String get navConfigHint2 => _localizedValues[locale.languageCode]?['navConfigHint2'] ?? '預設導航列為：課表、日曆、課程查詢、成績';
  String get navConfigHint3 => _localizedValues[locale.languageCode]?['navConfigHint3'] ?? '長按項目可拖曳調整順序';
  String get navConfigHint4 => _localizedValues[locale.languageCode]?['navConfigHint4'] ?? '未加入導航列的功能會顯示在「其他」頁面';
  String get navConfigHint5 => _localizedValues[locale.languageCode]?['navConfigHint5'] ?? '儲存後 App 會自動關閉，請重新開啟以套用配置';
  String get appWillCloseMessage => _localizedValues[locale.languageCode]?['appWillCloseMessage'] ?? '設定已儲存，App 即將關閉以套用新配置';

  // 星期
  String get monday => _localizedValues[locale.languageCode]?['monday'] ?? '星期一';
  String get tuesday => _localizedValues[locale.languageCode]?['tuesday'] ?? '星期二';
  String get wednesday => _localizedValues[locale.languageCode]?['wednesday'] ?? '星期三';
  String get thursday => _localizedValues[locale.languageCode]?['thursday'] ?? '星期四';
  String get friday => _localizedValues[locale.languageCode]?['friday'] ?? '星期五';
  String get saturday => _localizedValues[locale.languageCode]?['saturday'] ?? '星期六';
  
  // 課程詳情
  String get basicInfo => _localizedValues[locale.languageCode]?['basicInfo'] ?? '基本資訊';
  String get courseId => _localizedValues[locale.languageCode]?['courseId'] ?? '課號';
  String get credit => _localizedValues[locale.languageCode]?['credit'] ?? '學分';
  String get hours => _localizedValues[locale.languageCode]?['hours'] ?? '時數';
  String get courseStandard => _localizedValues[locale.languageCode]?['courseStandard'] ?? '課程標準';
  String get people => _localizedValues[locale.languageCode]?['people'] ?? '人數';
  String get withdraw => _localizedValues[locale.languageCode]?['withdraw'] ?? '退選';
  String get teachingLanguage => _localizedValues[locale.languageCode]?['teachingLanguage'] ?? '授課語言';
  String get teachers => _localizedValues[locale.languageCode]?['teachers'] ?? '授課教師';
  String get classes => _localizedValues[locale.languageCode]?['classes'] ?? '開課班級';
  String get timeAndLocation => _localizedValues[locale.languageCode]?['timeAndLocation'] ?? '上課時間與地點';
  String get courseDescription => _localizedValues[locale.languageCode]?['courseDescription'] ?? '課程概述';
  String get evaluationRules => _localizedValues[locale.languageCode]?['evaluationRules'] ?? '評分規則';
  String get notes => _localizedValues[locale.languageCode]?['notes'] ?? '備註';
  String get unknownTeacher => _localizedValues[locale.languageCode]?['unknownTeacher'] ?? '未知教師';
  String get noScorePolicy => _localizedValues[locale.languageCode]?['noScorePolicy'] ?? '此教師未提供評分規則';
  String get noCourseOutline => _localizedValues[locale.languageCode]?['noCourseOutline'] ?? '此課程目前無課程大綱資訊';
  
  // 成績
  String get courseName => _localizedValues[locale.languageCode]?['courseName'] ?? '課程名稱';
  String get grade => _localizedValues[locale.languageCode]?['grade'] ?? '成績';
  
  // 校務系統
  String get cannotLoadAdminSystem => _localizedValues[locale.languageCode]?['cannotLoadAdminSystem'] ?? '無法載入校務系統';
  String get noAvailableSystems => _localizedValues[locale.languageCode]?['noAvailableSystems'] ?? '沒有可用的系統';
  String get sunday => _localizedValues[locale.languageCode]?['sunday'] ?? '星期日';
  
  // 星期簡寫（用於課表）
  String get monShort => _localizedValues[locale.languageCode]?['monShort'] ?? '週一';
  String get tueShort => _localizedValues[locale.languageCode]?['tueShort'] ?? '週二';
  String get wedShort => _localizedValues[locale.languageCode]?['wedShort'] ?? '週三';
  String get thuShort => _localizedValues[locale.languageCode]?['thuShort'] ?? '週四';
  String get friShort => _localizedValues[locale.languageCode]?['friShort'] ?? '週五';
  String get satShort => _localizedValues[locale.languageCode]?['satShort'] ?? '週六';
  String get sunShort => _localizedValues[locale.languageCode]?['sunShort'] ?? '週日';
  
  // 單字符星期（用於課表內容）
  String get mon => _localizedValues[locale.languageCode]?['mon'] ?? '一';
  String get tue => _localizedValues[locale.languageCode]?['tue'] ?? '二';
  String get wed => _localizedValues[locale.languageCode]?['wed'] ?? '三';
  String get thu => _localizedValues[locale.languageCode]?['thu'] ?? '四';
  String get fri => _localizedValues[locale.languageCode]?['fri'] ?? '五';
  String get sat => _localizedValues[locale.languageCode]?['sat'] ?? '六';
  String get sun => _localizedValues[locale.languageCode]?['sun'] ?? '日';
  
  // 時間格式化相關
  String get justNow => _localizedValues[locale.languageCode]?['justNow'] ?? '剛剛';
  String get minutesAgo => _localizedValues[locale.languageCode]?['minutesAgo'] ?? '分鐘前';
  String get hoursAgo => _localizedValues[locale.languageCode]?['hoursAgo'] ?? '小時前';
  String get daysAgo => _localizedValues[locale.languageCode]?['daysAgo'] ?? '天前';
  String get updated => _localizedValues[locale.languageCode]?['updated'] ?? '更新';
  String get justUpdated => _localizedValues[locale.languageCode]?['justUpdated'] ?? '剛剛更新';
  
  // 日期格式（用於 DateFormat）
  String get dateFormatWithWeekday => _localizedValues[locale.languageCode]?['dateFormatWithWeekday'] ?? 'yyyy年MM月dd日 (E)';
  
  // 日曆頁面
  String get backToToday => _localizedValues[locale.languageCode]?['backToToday'] ?? '回到今天';
  String get reload => _localizedValues[locale.languageCode]?['reload'] ?? '重新載入';
  String get addEvent => _localizedValues[locale.languageCode]?['addEvent'] ?? '新增事件';
  String get noEventsOnThisDay => _localizedValues[locale.languageCode]?['noEventsOnThisDay'] ?? '這天沒有事件';
  String get loadFailed => _localizedValues[locale.languageCode]?['loadFailed'] ?? '載入失敗';
  String get retry => _localizedValues[locale.languageCode]?['retry'] ?? '重試';
  String get time => _localizedValues[locale.languageCode]?['time'] ?? '時間';
  String get date => _localizedValues[locale.languageCode]?['date'] ?? '日期';
  String get location => _localizedValues[locale.languageCode]?['location'] ?? '地點';
  String get description => _localizedValues[locale.languageCode]?['description'] ?? '說明';
  String get confirmDelete => _localizedValues[locale.languageCode]?['confirmDelete'] ?? '確認刪除';
  String confirmDeleteEvent(String title) => _localizedValues[locale.languageCode]?['confirmDeleteEvent']?.replaceAll('%s', title) ?? '確定要刪除「$title」嗎？';
  String get eventDeleted => _localizedValues[locale.languageCode]?['eventDeleted'] ?? '事件已刪除';
  String deleteFailed(String error) => _localizedValues[locale.languageCode]?['deleteFailed']?.replaceAll('%s', error) ?? '刪除失敗：$error';
  String get eventAdded => _localizedValues[locale.languageCode]?['eventAdded'] ?? '事件已新增';
  String addFailed(String error) => _localizedValues[locale.languageCode]?['addFailed']?.replaceAll('%s', error) ?? '新增失敗：$error';
  String get eventUpdated => _localizedValues[locale.languageCode]?['eventUpdated'] ?? '事件已更新';
  String updateFailed(String error) => _localizedValues[locale.languageCode]?['updateFailed']?.replaceAll('%s', error) ?? '更新失敗：$error';

  // 課表頁面
  String get noCourseData => _localizedValues[locale.languageCode]?['noCourseData'] ?? '沒有課程數據，無法設為小工具';
  String get noCoursesCurrently => _localizedValues[locale.languageCode]?['noCoursesCurrently'] ?? '目前沒有課程';
  String get lunchBreak => _localizedValues[locale.languageCode]?['lunchBreak'] ?? '午休';
  String get selectCourseColor => _localizedValues[locale.languageCode]?['selectCourseColor'] ?? '選擇課程顏色';
  String get generatingWidget => _localizedValues[locale.languageCode]?['generatingWidget'] ?? '正在生成小工具...';
  String get widgetUpdated => _localizedValues[locale.languageCode]?['widgetUpdated'] ?? '小工具已更新！請到桌面查看';
  String widgetUpdateFailed(String error) => _localizedValues[locale.languageCode]?['widgetUpdateFailed']?.replaceAll('%s', error) ?? '設為小工具失敗: $error';
  String get cannotGetSemesterList => _localizedValues[locale.languageCode]?['cannotGetSemesterList'] ?? '無法獲取可用學期列表';
  String get cannotGetSemesterListRetry => _localizedValues[locale.languageCode]?['cannotGetSemesterListRetry'] ?? '無法獲取學期列表，請稍後重試';
  String get updateFailedUseCached => _localizedValues[locale.languageCode]?['updateFailedUseCached'] ?? '更新失敗，使用緩存的學期列表';
  String loadSemesterFailed(String error) => _localizedValues[locale.languageCode]?['loadSemesterFailed']?.replaceAll('%s', error) ?? '載入學期列表失敗: $error';
  String loadFailed2(String error) => _localizedValues[locale.languageCode]?['loadFailed2']?.replaceAll('%s', error) ?? '載入失敗: $error';
  String get needLoginForLatest => _localizedValues[locale.languageCode]?['needLoginForLatest'] ?? '需要登入才能獲取最新課表';
  String get updateFailedShowCached => _localizedValues[locale.languageCode]?['updateFailedShowCached'] ?? '更新失敗,顯示緩存數據';
  String updateFailedMsg(String error) => _localizedValues[locale.languageCode]?['updateFailedMsg']?.replaceAll('%s', error) ?? '更新失敗:$error';
  String get needLogin => _localizedValues[locale.languageCode]?['needLogin'] ?? '需要登入';
  String get needLoginForCourseDesc => _localizedValues[locale.languageCode]?['needLoginForCourseDesc'] ?? '獲取最新課表需要登入。您可以選擇登入或繼續使用離線模式。';
  String get loginLater => _localizedValues[locale.languageCode]?['loginLater'] ?? '稍後登入';
  String get loginNow => _localizedValues[locale.languageCode]?['loginNow'] ?? '立即登入';
  String courseIdWithValue(String id) => _localizedValues[locale.languageCode]?['courseIdWithValue']?.replaceAll('%s', id) ?? '課號：$id';
  String creditsAndHours(String credits, String hours) => _localizedValues[locale.languageCode]?['creditsAndHours']?.replaceAll('%c', credits).replaceAll('%h', hours) ?? '學分：$credits / 時數：$hours';
  String instructor(String name) => _localizedValues[locale.languageCode]?['instructor']?.replaceAll('%s', name) ?? '教師：$name';
  String classroom(String room) => _localizedValues[locale.languageCode]?['classroom']?.replaceAll('%s', room) ?? '教室：$room';
  String scheduleTime(String time) => _localizedValues[locale.languageCode]?['scheduleTime']?.replaceAll('%s', time) ?? '時間：$time';
  String courseType(String type) => _localizedValues[locale.languageCode]?['courseType']?.replaceAll('%s', type) ?? '修別：$type';
  String get viewSyllabus => _localizedValues[locale.languageCode]?['viewSyllabus'] ?? '查看大綱';
  String get noSyllabus => _localizedValues[locale.languageCode]?['noSyllabus'] ?? '此課程無課程大綱資料';
  String get selectSemester => _localizedValues[locale.languageCode]?['selectSemester'] ?? '選擇學期';
  String get moreFeatures => _localizedValues[locale.languageCode]?['moreFeatures'] ?? '更多功能';
  String get refetchingCourseTable => _localizedValues[locale.languageCode]?['refetchingCourseTable'] ?? '重新取得課表中...';
  String get refetchingSemesterList => _localizedValues[locale.languageCode]?['refetchingSemesterList'] ?? '重新取得學期列表中...';
  String get setAsDesktopWidget => _localizedValues[locale.languageCode]?['setAsDesktopWidget'] ?? '設為桌面小工具';
  String get refreshCourseTable => _localizedValues[locale.languageCode]?['refreshCourseTable'] ?? '刷新課表';
  String get refreshSemesterList => _localizedValues[locale.languageCode]?['refreshSemesterList'] ?? '刷新學期列表';
  String get courseTableFeatureName => _localizedValues[locale.languageCode]?['courseTableFeatureName'] ?? '課表';
  String get courseTableLoginDesc => _localizedValues[locale.languageCode]?['courseTableLoginDesc'] ?? '查看課表需要登入\n登入後系統會自動緩存課表數據';
  
  // i學園相關
  String get iSchoolLoginDesc => _localizedValues[locale.languageCode]?['iSchoolLoginDesc'] ?? '訪客模式無法使用 i學園\n這是在線功能，需要登入後才能查看課程公告、下載教材';
  String announcementCache(String size) => _localizedValues[locale.languageCode]?['announcementCache']?.replaceAll('%s', size) ?? '公告快取：$size';
  String downloadFiles(String size) => _localizedValues[locale.languageCode]?['downloadFiles']?.replaceAll('%s', size) ?? '下載檔案：$size';
  String total(String size) => _localizedValues[locale.languageCode]?['total']?.replaceAll('%s', size) ?? '總計：$size';

  // 登入頁面
  String get studentId => _localizedValues[locale.languageCode]?['studentId'] ?? '學號';
  String get pleaseEnterStudentId => _localizedValues[locale.languageCode]?['pleaseEnterStudentId'] ?? '請輸入學號';
  String get password => _localizedValues[locale.languageCode]?['password'] ?? '密碼';
  String get pleaseEnterPassword => _localizedValues[locale.languageCode]?['pleaseEnterPassword'] ?? '請輸入密碼';
  String get login => _localizedValues[locale.languageCode]?['login'] ?? '登入';
  String get browseAsGuest => _localizedValues[locale.languageCode]?['browseAsGuest'] ?? '以訪客模式瀏覽';
  String get agreeToTerms => _localizedValues[locale.languageCode]?['agreeToTerms'] ?? '我已閱讀並同意';
  String get privacyPolicy => _localizedValues[locale.languageCode]?['privacyPolicy'] ?? '隱私權條款';
  String get and => _localizedValues[locale.languageCode]?['and'] ?? '和';
  String get termsOfService => _localizedValues[locale.languageCode]?['termsOfService'] ?? '使用者條款';
  String get pleaseAgreeToTerms => _localizedValues[locale.languageCode]?['pleaseAgreeToTerms'] ?? '請先同意隱私權條款和使用者條款';
  String get loginFailed => _localizedValues[locale.languageCode]?['loginFailed'] ?? '登入失敗';
  String loginFailedWithError(String error) => _localizedValues[locale.languageCode]?['loginFailedWithError']?.replaceAll('%s', error) ?? '登入失敗：$error';
  String get guestModeActivated => _localizedValues[locale.languageCode]?['guestModeActivated'] ?? '已進入訪客模式，可查看緩存資料';
  
  // 主題顏色名稱
  String get colorBlue => _localizedValues[locale.languageCode]?['colorBlue'] ?? '藍色';
  String get colorPurple => _localizedValues[locale.languageCode]?['colorPurple'] ?? '紫色';
  String get colorGreen => _localizedValues[locale.languageCode]?['colorGreen'] ?? '綠色';
  String get colorOrange => _localizedValues[locale.languageCode]?['colorOrange'] ?? '橙色';
  String get colorRed => _localizedValues[locale.languageCode]?['colorRed'] ?? '紅色';
  String get colorPink => _localizedValues[locale.languageCode]?['colorPink'] ?? '粉紅';
  String get colorTeal => _localizedValues[locale.languageCode]?['colorTeal'] ?? '青綠';
  String get colorIndigo => _localizedValues[locale.languageCode]?['colorIndigo'] ?? '靛藍';
  String get colorYellow => _localizedValues[locale.languageCode]?['colorYellow'] ?? '黃色';

  // 通用動作詞
  String get reset => _localizedValues[locale.languageCode]?['reset'] ?? '重置';
  String get complete => _localizedValues[locale.languageCode]?['complete'] ?? '完成';
  String get done => _localizedValues[locale.languageCode]?['done'] ?? '完成';
  String get open => _localizedValues[locale.languageCode]?['open'] ?? '開啟';
  String get share => _localizedValues[locale.languageCode]?['share'] ?? '分享';
  String get download => _localizedValues[locale.languageCode]?['download'] ?? '下載';
  String get downloaded => _localizedValues[locale.languageCode]?['downloaded'] ?? '已下載';
  
  // 事件相關
  String get allDayEvent => _localizedValues[locale.languageCode]?['allDayEvent'] ?? '全天事件';
  String get endTimeBeforeStart => _localizedValues[locale.languageCode]?['endTimeBeforeStart'] ?? '結束時間不能早於開始時間';
  String get editEvent => _localizedValues[locale.languageCode]?['editEvent'] ?? '編輯事件';
  String get title => _localizedValues[locale.languageCode]?['title'] ?? '標題';
  String get titleRequired => _localizedValues[locale.languageCode]?['titleRequired'] ?? '標題 *';
  String get pleaseEnterTitle => _localizedValues[locale.languageCode]?['pleaseEnterTitle'] ?? '請輸入標題';
  String get moreOptions => _localizedValues[locale.languageCode]?['moreOptions'] ?? '更多選項';
  String get color => _localizedValues[locale.languageCode]?['color'] ?? '顏色';
  String get startTime => _localizedValues[locale.languageCode]?['startTime'] ?? '開始時間';
  String get endTime => _localizedValues[locale.languageCode]?['endTime'] ?? '結束時間';
  String get notSet => _localizedValues[locale.languageCode]?['notSet'] ?? '未設定';
  String get recurrence => _localizedValues[locale.languageCode]?['recurrence'] ?? '重複';
  String get noRecurrence => _localizedValues[locale.languageCode]?['noRecurrence'] ?? '不重複';
  String get daily => _localizedValues[locale.languageCode]?['daily'] ?? '每天';
  String get weekly => _localizedValues[locale.languageCode]?['weekly'] ?? '每週';
  String get monthly => _localizedValues[locale.languageCode]?['monthly'] ?? '每月';
  String get yearly => _localizedValues[locale.languageCode]?['yearly'] ?? '每年';
  String get selectEndDateOptional => _localizedValues[locale.languageCode]?['selectEndDateOptional'] ?? '選擇結束日期（選填）';
  String endOn(String date) => _localizedValues[locale.languageCode]?['endOn']?.replaceAll('%s', date) ?? '結束於：$date';
  
  // 通知設定
  String get notificationSettings => _localizedValues[locale.languageCode]?['notificationSettings'] ?? '通知設定';
  String get hideAllBadges => _localizedValues[locale.languageCode]?['hideAllBadges'] ?? '隱藏所有紅點';
  String get hideAllBadgesDesc => _localizedValues[locale.languageCode]?['hideAllBadgesDesc'] ?? '隱藏 App 中的所有紅點通知';
  String get autoCheckAnnouncements => _localizedValues[locale.languageCode]?['autoCheckAnnouncements'] ?? '自動檢查公告';
  String get autoCheckAnnouncementsDesc => _localizedValues[locale.languageCode]?['autoCheckAnnouncementsDesc'] ?? '登入時自動檢查新公告';
  String get manageNotificationSettings => _localizedValues[locale.languageCode]?['manageNotificationSettings'] ?? '管理紅點通知與自動檢查';
  
  // 重新登入相關
  String get reloginUsingSaved => _localizedValues[locale.languageCode]?['reloginUsingSaved'] ?? '使用儲存的帳號密碼重新登入';
  String get reloggingIn => _localizedValues[locale.languageCode]?['reloggingIn'] ?? '重新登入中...';
  String get reloginSuccess => _localizedValues[locale.languageCode]?['reloginSuccess'] ?? '重新登入成功';
  String get reloginFailed => _localizedValues[locale.languageCode]?['reloginFailed'] ?? '重新登入失敗，請檢查網路連線或帳號密碼';
  String get noSavedCredentials => _localizedValues[locale.languageCode]?['noSavedCredentials'] ?? '沒有保存的帳號密碼，請前往登入';
  String reloginFailedWithError(String error) => _localizedValues[locale.languageCode]?['reloginFailedWithError']?.replaceAll('%s', error) ?? '重新登入失敗: $error';
  String get cannotOpenFeedback => _localizedValues[locale.languageCode]?['cannotOpenFeedback'] ?? '無法開啟反饋頁面';
  String cannotOpenFeedbackWithError(String error) => _localizedValues[locale.languageCode]?['cannotOpenFeedbackWithError']?.replaceAll('%s', error) ?? '無法開啟反饋頁面: $error';
  
  // 北科i學院相關
  String get clearISchoolData => _localizedValues[locale.languageCode]?['clearISchoolData'] ?? '清除 i學院 資料';
  String get thisWillClear => _localizedValues[locale.languageCode]?['thisWillClear'] ?? '這將會清除：';
  String get clearing => _localizedValues[locale.languageCode]?['clearing'] ?? '清除中...';
  String get allISchoolDataCleared => _localizedValues[locale.languageCode]?['allISchoolDataCleared'] ?? '已清除所有 i學院 資料';
  String clearFailedWithError(String error) => _localizedValues[locale.languageCode]?['clearFailedWithError']?.replaceAll('%s', error) ?? '清除失敗：$error';
  String get allISchoolBadgesCleared => _localizedValues[locale.languageCode]?['allISchoolBadgesCleared'] ?? '已清除所有 i學院 紅點';
  String clearBadgesFailedWithError(String error) => _localizedValues[locale.languageCode]?['clearBadgesFailedWithError']?.replaceAll('%s', error) ?? '清除紅點失敗：$error';
  String markFailedWithError(String error) => _localizedValues[locale.languageCode]?['markFailedWithError']?.replaceAll('%s', error) ?? '標記失敗：$error';
  String get clearCacheAndFiles => _localizedValues[locale.languageCode]?['clearCacheAndFiles'] ?? '清除快取與檔案';
  String get markAllAsRead => _localizedValues[locale.languageCode]?['markAllAsRead'] ?? '標記全部已讀';
  String get markAllAsUnread => _localizedValues[locale.languageCode]?['markAllAsUnread'] ?? '標記全部未讀';
  String get loadingCourses => _localizedValues[locale.languageCode]?['loadingCourses'] ?? '載入課程中...';
  String get noCoursesFound => _localizedValues[locale.languageCode]?['noCoursesFound'] ?? '沒有找到課程';
  String get reloadCourses => _localizedValues[locale.languageCode]?['reloadCourses'] ?? '重新載入';
  String get courseAnnouncements => _localizedValues[locale.languageCode]?['courseAnnouncements'] ?? '課程公告';
  String get courseMaterials => _localizedValues[locale.languageCode]?['courseMaterials'] ?? '課程教材';
  
  // 文件操作相關
  String get confirmToOpen => _localizedValues[locale.languageCode]?['confirmToOpen'] ?? '確定要打開嗎？';
  String get externalLink => _localizedValues[locale.languageCode]?['externalLink'] ?? '這是一個外部連結';
  String get classRecording => _localizedValues[locale.languageCode]?['classRecording'] ?? '上課錄影';
  String get classRecordingWarning => _localizedValues[locale.languageCode]?['classRecordingWarning'] ?? '注意：影片可能會載入失敗，若失敗請重試或使用瀏覽器開啟';
  String downloadStarted(String fileName) => _localizedValues[locale.languageCode]?['downloadStarted']?.replaceAll('%s', fileName) ?? '開始下載：$fileName';
  String downloadCompleted(String fileName) => _localizedValues[locale.languageCode]?['downloadCompleted']?.replaceAll('%s', fileName) ?? '下載完成：$fileName';
  String downloadFailedWithError(String error) => _localizedValues[locale.languageCode]?['downloadFailedWithError']?.replaceAll('%s', error) ?? '下載失敗：$error';
  String openFileFailedWithError(String error) => _localizedValues[locale.languageCode]?['openFileFailedWithError']?.replaceAll('%s', error) ?? '開啟檔案失敗：$error';
  String shareFailedWithError(String error) => _localizedValues[locale.languageCode]?['shareFailedWithError']?.replaceAll('%s', error) ?? '分享失敗：$error';
  String fileDeleted(String fileName) => _localizedValues[locale.languageCode]?['fileDeleted']?.replaceAll('%s', fileName) ?? '已刪除：$fileName';
  String deleteFailedWithError(String error) => _localizedValues[locale.languageCode]?['deleteFailedWithError']?.replaceAll('%s', error) ?? '刪除失敗：$error';
  String get deleteFile => _localizedValues[locale.languageCode]?['deleteFile'] ?? '刪除檔案';
  String confirmDeleteFile(String fileName) => _localizedValues[locale.languageCode]?['confirmDeleteFile']?.replaceAll('%s', fileName) ?? '確定要刪除「$fileName」嗎？';
  String get openedInBrowser => _localizedValues[locale.languageCode]?['openedInBrowser'] ?? '已在瀏覽器中開啟';
  String get cannotAutoOpenBrowser => _localizedValues[locale.languageCode]?['cannotAutoOpenBrowser'] ?? '無法自動開啟瀏覽器，已複製網址';
  String get copiedToClipboard => _localizedValues[locale.languageCode]?['copiedToClipboard'] ?? '已複製到剪貼簿';
  String copyFailedWithError(String error) => _localizedValues[locale.languageCode]?['copyFailedWithError']?.replaceAll('%s', error) ?? '複製失敗：$error';
  String errorWithValue(String error) => _localizedValues[locale.languageCode]?['errorWithValue']?.replaceAll('%s', error) ?? '錯誤:$error';
  String loadCourseFailedWithError(String error) => _localizedValues[locale.languageCode]?['loadCourseFailedWithError']?.replaceAll('%s', error) ?? '載入課程失敗：$error';
  String cannotOpenLink(String url) => _localizedValues[locale.languageCode]?['cannotOpenLink']?.replaceAll('%s', url) ?? '無法開啟連結：$url';
  String openLinkFailedWithError(String error) => _localizedValues[locale.languageCode]?['openLinkFailedWithError']?.replaceAll('%s', error) ?? '開啟連結失敗：$error';
  String get noAnnouncementContent => _localizedValues[locale.languageCode]?['noAnnouncementContent'] ?? '無公告內容';
  
  // 公告列表頁面
  String get loginISchoolFailed => _localizedValues[locale.languageCode]?['loginISchoolFailed'] ?? '登入 i學院失敗，請稍後再試';
  String get noCourseAnnouncements => _localizedValues[locale.languageCode]?['noCourseAnnouncements'] ?? '此課程目前沒有公告';
  String get loadAnnouncementsFailed => _localizedValues[locale.languageCode]?['loadAnnouncementsFailed'] ?? '載入公告失敗，請稍後再試';
  String get loadAnnouncementDetailFailed => _localizedValues[locale.languageCode]?['loadAnnouncementDetailFailed'] ?? '載入公告詳情時發生錯誤';
  String loadAnnouncementDetailFailedWithError(String error) => _localizedValues[locale.languageCode]?['loadAnnouncementDetailFailedWithError']?.replaceAll('%s', error) ?? '載入公告詳情時發生錯誤：$error';
  String get cannotLoadAnnouncementDetail => _localizedValues[locale.languageCode]?['cannotLoadAnnouncementDetail'] ?? '無法載入公告詳情';
  String get cannotGetLatestAnnouncementContent => _localizedValues[locale.languageCode]?['cannotGetLatestAnnouncementContent'] ?? '無法獲取最新的公告內容';
  String cannotFindAttachment(String fileName) => _localizedValues[locale.languageCode]?['cannotFindAttachment']?.replaceAll('%s', fileName) ?? '找不到附件：$fileName';
  String downloadCompletedWithFileName(String fileName) => _localizedValues[locale.languageCode]?['downloadCompletedWithFileName']?.replaceAll('%s', fileName) ?? '下載完成：$fileName';
  String get fileNotFound => _localizedValues[locale.languageCode]?['fileNotFound'] ?? '檔案不存在';
  String get openFileFailed => _localizedValues[locale.languageCode]?['openFileFailed'] ?? '開啟檔案失敗';
  String get noAppToOpenFile => _localizedValues[locale.languageCode]?['noAppToOpenFile'] ?? '沒有可開啟此檔案的應用程式';
  String get fileNotFoundError => _localizedValues[locale.languageCode]?['fileNotFoundError'] ?? '找不到檔案';
  String get permissionDenied => _localizedValues[locale.languageCode]?['permissionDenied'] ?? '權限被拒絕';
  String openFileErrorWithMessage(String message) => _localizedValues[locale.languageCode]?['openFileErrorWithMessage']?.replaceAll('%s', message) ?? '開啟檔案時發生錯誤：$message';
  String get downloaded_clickToOpen => _localizedValues[locale.languageCode]?['downloaded_clickToOpen'] ?? '已下載 · 點擊開啟';
  String get clickToDownload => _localizedValues[locale.languageCode]?['clickToDownload'] ?? '點擊下載';
  
  // 選擇器相關
  String get classCategory => _localizedValues[locale.languageCode]?['classCategory'] ?? '班級';
  String get microProgram => _localizedValues[locale.languageCode]?['microProgram'] ?? '微學程';
  String get loadCollegeStructureFailed => _localizedValues[locale.languageCode]?['loadCollegeStructureFailed'] ?? '載入學院結構失敗';
  String get loadMicroProgramsFailed => _localizedValues[locale.languageCode]?['loadMicroProgramsFailed'] ?? '載入微學程列表失敗';
  String get pleaseSelectCollege => _localizedValues[locale.languageCode]?['pleaseSelectCollege'] ?? '請選擇學院';
  String get pleaseSelectCollegeFirst => _localizedValues[locale.languageCode]?['pleaseSelectCollegeFirst'] ?? '請先選擇學院';
  
  // 成績與學分相關
  String get noGradeData => _localizedValues[locale.languageCode]?['noGradeData'] ?? '沒有成績資料';
  String get noData => _localizedValues[locale.languageCode]?['noData'] ?? '暫無資料';
  String get pleaseSetGraduationStandard => _localizedValues[locale.languageCode]?['pleaseSetGraduationStandard'] ?? '請先設定畢業標準';
  String get setGraduationStandard => _localizedValues[locale.languageCode]?['setGraduationStandard'] ?? '設定畢業標準';
  String get graduationStandardSettings => _localizedValues[locale.languageCode]?['graduationStandardSettings'] ?? '畢業學分標準設定';
  String get liberalArtsCreditsDetail => _localizedValues[locale.languageCode]?['liberalArtsCreditsDetail'] ?? '博雅學分詳情';
  String get nonDepartmentCredits => _localizedValues[locale.languageCode]?['nonDepartmentCredits'] ?? '外系學分';
  
  // 學分頁面新增
  String get graduationSettings => _localizedValues[locale.languageCode]?['graduationSettings'] ?? '設定畢業標準';
  String get preparingLoad => _localizedValues[locale.languageCode]?['preparingLoad'] ?? '準備載入...';
  String queryingCourseInfo(int current, int total) => _localizedValues[locale.languageCode]?['queryingCourseInfo']?.replaceAll('%c', '$current').replaceAll('%t', '$total') ?? '正在查詢課程資訊... ($current/$total)';
  String loadFailedWith(String error) => _localizedValues[locale.languageCode]?['loadFailedWith']?.replaceAll('%s', error) ?? '載入失敗: $error';
  String get creditCalculation => _localizedValues[locale.languageCode]?['creditCalculation'] ?? '學分計算';
  String get cannotViewCreditsInGuest => _localizedValues[locale.languageCode]?['cannotViewCreditsInGuest'] ?? '訪客模式無法查看學分\n登入後可查看並緩存學分資料';
  String get creditOverview => _localizedValues[locale.languageCode]?['creditOverview'] ?? '學分總覽';
  String get graduationThreshold => _localizedValues[locale.languageCode]?['graduationThreshold'] ?? '畢業門檻';
  String get stillNeed => _localizedValues[locale.languageCode]?['stillNeed'] ?? '還需';
  String get progress => _localizedValues[locale.languageCode]?['progress'] ?? '進度';
  String get courseTypeCredits => _localizedValues[locale.languageCode]?['courseTypeCredits'] ?? '各類課程學分';
  String get requiredCommonCore => _localizedValues[locale.languageCode]?['requiredCommonCore'] ?? '部訂共同必修';
  String get requiredSchoolCore => _localizedValues[locale.languageCode]?['requiredSchoolCore'] ?? '校訂共同必修';
  String get electiveCommon => _localizedValues[locale.languageCode]?['electiveCommon'] ?? '共同選修';
  String get requiredMajorCore => _localizedValues[locale.languageCode]?['requiredMajorCore'] ?? '部訂專業必修';
  String get requiredMajorSchool => _localizedValues[locale.languageCode]?['requiredMajorSchool'] ?? '校訂專業必修';
  String get electiveMajor => _localizedValues[locale.languageCode]?['electiveMajor'] ?? '專業選修';
  String get boyaCredits => _localizedValues[locale.languageCode]?['boyaCredits'] ?? '博雅學分';
  String earned(int credits) => _localizedValues[locale.languageCode]?['earned']?.replaceAll('%d', '$credits') ?? '已修 $credits';
  String requiredCreditsCount(int credits) => _localizedValues[locale.languageCode]?['requiredCreditsCount']?.replaceAll('%d', '$credits') ?? '需求 $credits';
  String get boyaDetails => _localizedValues[locale.languageCode]?['boyaDetails'] ?? '博雅學分詳情';
  String dimensionCredits(String dimension, int earned, int required) => _localizedValues[locale.languageCode]?['dimensionCredits']?.replaceAll('%d', dimension).replaceAll('%e', '$earned').replaceAll('%r', '$required') ?? '$dimension ($earned / $required 學分)';
  String get freeChoice => _localizedValues[locale.languageCode]?['freeChoice'] ?? '自由選修';
  String creditsValue(int credits) => _localizedValues[locale.languageCode]?['creditsValue']?.replaceAll('%d', '$credits') ?? '$credits 學分';
  String get otherDepartmentCredits => _localizedValues[locale.languageCode]?['otherDepartmentCredits'] ?? '外系學分';
  String earnedMax(int earned, int max) => _localizedValues[locale.languageCode]?['earnedMax']?.replaceAll('%e', '$earned').replaceAll('%m', '$max') ?? '已修 $earned / 上限 $max';
  
  // 課程大綱相關
  String get loadingSyllabus => _localizedValues[locale.languageCode]?['loadingSyllabus'] ?? '載入課程大綱中...';
  String get goToLogin => _localizedValues[locale.languageCode]?['goToLogin'] ?? '前往登入';
  String get noSyllabusData => _localizedValues[locale.languageCode]?['noSyllabusData'] ?? '無課程大綱資料';
  String get courseSyllabus => _localizedValues[locale.languageCode]?['courseSyllabus'] ?? '課程大綱';
  String get courseObjective => _localizedValues[locale.languageCode]?['courseObjective'] ?? '課程目標';
  String get courseOutline => _localizedValues[locale.languageCode]?['courseOutline'] ?? '課程大綱';
  String get teacherContactInfo => _localizedValues[locale.languageCode]?['teacherContactInfo'] ?? '老師聯絡資訊';
  String get textbooks => _localizedValues[locale.languageCode]?['textbooks'] ?? '教科書';
  String get referenceBooks => _localizedValues[locale.languageCode]?['referenceBooks'] ?? '參考書目';
  String get gradingMethod => _localizedValues[locale.languageCode]?['gradingMethod'] ?? '評量方式';
  String get gradingStandard => _localizedValues[locale.languageCode]?['gradingStandard'] ?? '評量標準';
  
  // 課程查詢相關
  String get courseSearchPlaceholder => _localizedValues[locale.languageCode]?['courseSearchPlaceholder'] ?? '課程名稱、教師、課號';
  String get teacher => _localizedValues[locale.languageCode]?['teacher'] ?? '教師';
  String get teacherName => _localizedValues[locale.languageCode]?['teacherName'] ?? '授課教師';
  String get classTime => _localizedValues[locale.languageCode]?['classTime'] ?? '上課時間';
  String get classTimeAndPlace => _localizedValues[locale.languageCode]?['classTimeAndPlace'] ?? '上課時間與地點';
  String get required => _localizedValues[locale.languageCode]?['required'] ?? '必修';
  String get elective => _localizedValues[locale.languageCode]?['elective'] ?? '選修';
  String get generalEducation => _localizedValues[locale.languageCode]?['generalEducation'] ?? '通識';
  String get liberalArts => _localizedValues[locale.languageCode]?['liberalArts'] ?? '博雅';
  String get department => _localizedValues[locale.languageCode]?['department'] ?? '系所';
  String get professional => _localizedValues[locale.languageCode]?['professional'] ?? '專業';
  String get common => _localizedValues[locale.languageCode]?['common'] ?? '共同';
  
  // 成績相關
  String get overallStats => _localizedValues[locale.languageCode]?['overallStats'] ?? '整體統計';
  String get semesterGrades => _localizedValues[locale.languageCode]?['semesterGrades'] ?? '學期成績';
  String get averageScore => _localizedValues[locale.languageCode]?['averageScore'] ?? '平均成績';
  String get performanceScore => _localizedValues[locale.languageCode]?['performanceScore'] ?? '操行成績';
  String get takenCredits => _localizedValues[locale.languageCode]?['takenCredits'] ?? '修習學分';
  String get obtainedCredits => _localizedValues[locale.languageCode]?['obtainedCredits'] ?? '獲得學分';
  String get gpa => _localizedValues[locale.languageCode]?['gpa'] ?? '學期平均';
  String get overallGpa => _localizedValues[locale.languageCode]?['overallGpa'] ?? '總平均';
  String get rank => _localizedValues[locale.languageCode]?['rank'] ?? '排名';
  String get overallRank => _localizedValues[locale.languageCode]?['overallRank'] ?? '總排名';
  String get classRank => _localizedValues[locale.languageCode]?['classRank'] ?? '班排';
  String get departmentRank => _localizedValues[locale.languageCode]?['departmentRank'] ?? '系排';
  String get classRankFull => _localizedValues[locale.languageCode]?['classRankFull'] ?? '班排名';
  String get departmentRankFull => _localizedValues[locale.languageCode]?['departmentRankFull'] ?? '系排名';
  String topPercentage(String percentage) => _localizedValues[locale.languageCode]?['topPercentage']?.replaceAll('%p', percentage) ?? '前 $percentage%';
  String get totalStudents => _localizedValues[locale.languageCode]?['totalStudents'] ?? '總人數';
  String get earnedCredits => _localizedValues[locale.languageCode]?['earnedCredits'] ?? '取得學分';
  String get failedCredits => _localizedValues[locale.languageCode]?['failedCredits'] ?? '未通過學分';
  String get totalCredits => _localizedValues[locale.languageCode]?['totalCredits'] ?? '總學分';
  String get score => _localizedValues[locale.languageCode]?['score'] ?? '分數';
  String get pass => _localizedValues[locale.languageCode]?['pass'] ?? '通過';
  String get fail => _localizedValues[locale.languageCode]?['fail'] ?? '不及格';
  String failedCoursesCount(int count) => _localizedValues[locale.languageCode]?['failedCoursesCount']?.replaceAll('%d', count.toString()) ?? '$count 門課程不及格';
  String get courseCredit => _localizedValues[locale.languageCode]?['courseCredit'] ?? '學分';
  String get courseCount => _localizedValues[locale.languageCode]?['courseCount'] ?? '課程數';
  String get midtermScore => _localizedValues[locale.languageCode]?['midtermScore'] ?? '期中成績';
  String get finalScore => _localizedValues[locale.languageCode]?['finalScore'] ?? '期末成績';
  String get usualScore => _localizedValues[locale.languageCode]?['usualScore'] ?? '平時成績';
  String get loadGradesFailed => _localizedValues[locale.languageCode]?['loadGradesFailed'] ?? '載入成績失敗';
  String get cannotGetStudentId => _localizedValues[locale.languageCode]?['cannotGetStudentId'] ?? '無法取得學號';
  String get gradesFeatureName => _localizedValues[locale.languageCode]?['gradesFeatureName'] ?? '成績';
  String get gradesLoginDesc => _localizedValues[locale.languageCode]?['gradesLoginDesc'] ?? '訪客模式無法查看成績\n登入後可查看並緩存成績資料';
  String get semesterGradesList => _localizedValues[locale.languageCode]?['semesterGradesList'] ?? '各學期成績';
  String semesterSummary(String average, String earned, String total) {
    final template = _localizedValues[locale.languageCode]?['semesterSummary'] ?? '平均: %a | 學分: %e/%t';
    return template.replaceAll('%a', average).replaceAll('%e', earned).replaceAll('%t', total);
  }
  
  // 學分統計相關
  String get creditStats => _localizedValues[locale.languageCode]?['creditStats'] ?? '學分統計';
  String get graduationRequirement => _localizedValues[locale.languageCode]?['graduationRequirement'] ?? '畢業門檻';
  String get requiredCredits => _localizedValues[locale.languageCode]?['requiredCredits'] ?? '必修學分';
  String get electiveCredits => _localizedValues[locale.languageCode]?['electiveCredits'] ?? '選修學分';
  String get liberalArtsCredits => _localizedValues[locale.languageCode]?['liberalArtsCredits'] ?? '博雅學分';
  String get professionalRequired => _localizedValues[locale.languageCode]?['professionalRequired'] ?? '專業必修';
  String get professionalElective => _localizedValues[locale.languageCode]?['professionalElective'] ?? '專業選修';
  String get commonRequired => _localizedValues[locale.languageCode]?['commonRequired'] ?? '共同必修';
  String get commonElective => _localizedValues[locale.languageCode]?['commonElective'] ?? '共同選修';
  String get freeElective => _localizedValues[locale.languageCode]?['freeElective'] ?? '自由選修';
  String get creditsProgress => _localizedValues[locale.languageCode]?['creditsProgress'] ?? '學分進度';
  String get remaining => _localizedValues[locale.languageCode]?['remaining'] ?? '還需';
  String get completed => _localizedValues[locale.languageCode]?['completed'] ?? '已完成';
  String get inProgress => _localizedValues[locale.languageCode]?['inProgress'] ?? '進行中';
  String creditUnit(int count) => _localizedValues[locale.languageCode]?['creditUnit']?.replaceAll('%d', count.toString()) ?? '$count 學分';
  String get minimumGraduationCredits => _localizedValues[locale.languageCode]?['minimumGraduationCredits'] ?? '最低畢業學分';
  String get currentTotalCredits => _localizedValues[locale.languageCode]?['currentTotalCredits'] ?? '目前總學分';
  String get creditsNeeded => _localizedValues[locale.languageCode]?['creditsNeeded'] ?? '還需學分';
  
  // 學院、系所、班級相關
  String get college => _localizedValues[locale.languageCode]?['college'] ?? '學院';
  String get selectCollege => _localizedValues[locale.languageCode]?['selectCollege'] ?? '選擇學院';
  String get departmentOrProgram => _localizedValues[locale.languageCode]?['departmentOrProgram'] ?? '系所';
  String get selectDepartment => _localizedValues[locale.languageCode]?['selectDepartment'] ?? '選擇系所';
  String get classGrade => _localizedValues[locale.languageCode]?['classGrade'] ?? '班級';
  String get selectClass => _localizedValues[locale.languageCode]?['selectClass'] ?? '選擇班級';
  String get selectClassOrProgram => _localizedValues[locale.languageCode]?['selectClassOrProgram'] ?? '選擇班級或學程';
  String get program => _localizedValues[locale.languageCode]?['program'] ?? '學程';
  String get gradeLevel => _localizedValues[locale.languageCode]?['gradeLevel'] ?? '年級';
  String get academicYear => _localizedValues[locale.languageCode]?['academicYear'] ?? '學年度';
  String get openingClass => _localizedValues[locale.languageCode]?['openingClass'] ?? '開課班級';
  String get classInfo => _localizedValues[locale.languageCode]?['classInfo'] ?? '班級資訊';
  String get educationSystem => _localizedValues[locale.languageCode]?['educationSystem'] ?? '學制';
  String get unknownCourse => _localizedValues[locale.languageCode]?['unknownCourse'] ?? '未知課程';
  
  // 空教室查詢相關
  String get emptyClassroomQuery => _localizedValues[locale.languageCode]?['emptyClassroomQuery'] ?? '空教室查詢';
  String get building => _localizedValues[locale.languageCode]?['building'] ?? '建築';
  String get floor => _localizedValues[locale.languageCode]?['floor'] ?? '樓層';
  String get room => _localizedValues[locale.languageCode]?['room'] ?? '教室';
  String get available => _localizedValues[locale.languageCode]?['available'] ?? '空';
  String get occupied => _localizedValues[locale.languageCode]?['occupied'] ?? '忙';
  String get selectTimeSlot => _localizedValues[locale.languageCode]?['selectTimeSlot'] ?? '選擇時段';
  String get selectBuilding => _localizedValues[locale.languageCode]?['selectBuilding'] ?? '選擇教學大樓';
  String get noEmptyClassrooms => _localizedValues[locale.languageCode]?['noEmptyClassrooms'] ?? '沒有空教室';
  String get searchResults => _localizedValues[locale.languageCode]?['searchResults'] ?? '搜尋結果';
  
  // 其他通用字串
  String get filter => _localizedValues[locale.languageCode]?['filter'] ?? '篩選';
  String get sort => _localizedValues[locale.languageCode]?['sort'] ?? '排序';
  String get ascending => _localizedValues[locale.languageCode]?['ascending'] ?? '升序';
  String get descending => _localizedValues[locale.languageCode]?['descending'] ?? '降序';
  String get all => _localizedValues[locale.languageCode]?['all'] ?? '全部';
  String get none => _localizedValues[locale.languageCode]?['none'] ?? '無';
  String get selectAll => _localizedValues[locale.languageCode]?['selectAll'] ?? '全選';
  String get deselectAll => _localizedValues[locale.languageCode]?['deselectAll'] ?? '取消全選';
  String get apply => _localizedValues[locale.languageCode]?['apply'] ?? '套用';
  String get clear => _localizedValues[locale.languageCode]?['clear'] ?? '清除';
  String get refresh => _localizedValues[locale.languageCode]?['refresh'] ?? '重新整理';
  String get more => _localizedValues[locale.languageCode]?['more'] ?? '更多';
  String get less => _localizedValues[locale.languageCode]?['less'] ?? '較少';
  String get detail => _localizedValues[locale.languageCode]?['detail'] ?? '詳情';
  String get details => _localizedValues[locale.languageCode]?['details'] ?? '詳細資訊';
  String get information => _localizedValues[locale.languageCode]?['information'] ?? '資訊';
  String get notice => _localizedValues[locale.languageCode]?['notice'] ?? '公告';
  String get announcement => _localizedValues[locale.languageCode]?['announcement'] ?? '公告';
  String get attachment => _localizedValues[locale.languageCode]?['attachment'] ?? '附件';
  String get attachments => _localizedValues[locale.languageCode]?['attachments'] ?? '附件';
  String get noAttachments => _localizedValues[locale.languageCode]?['noAttachments'] ?? '無附件';
  String get viewDetails => _localizedValues[locale.languageCode]?['viewDetails'] ?? '查看詳情';
  String get backToList => _localizedValues[locale.languageCode]?['backToList'] ?? '返回列表';
  
  // 關於頁面
  String get contributors => _localizedValues[locale.languageCode]?['contributors'] ?? '貢獻者';
  String get seniorContributors => _localizedValues[locale.languageCode]?['seniorContributors'] ?? '元老級貢獻者';
  String get specialThanks => _localizedValues[locale.languageCode]?['specialThanks'] ?? '特別感謝';
  String get legalInformation => _localizedValues[locale.languageCode]?['legalInformation'] ?? '法律資訊';
  String get privacyPolicyTitle => _localizedValues[locale.languageCode]?['privacyPolicyTitle'] ?? '隱私權條款';
  String get privacyPolicyDesc => _localizedValues[locale.languageCode]?['privacyPolicyDesc'] ?? '了解我們如何保護您的隱私';
  String get termsOfServiceTitle => _localizedValues[locale.languageCode]?['termsOfServiceTitle'] ?? '使用者條款';
  String get termsOfServiceDesc => _localizedValues[locale.languageCode]?['termsOfServiceDesc'] ?? '使用服務前請詳閱本條款';
  String get openSourceProject => _localizedValues[locale.languageCode]?['openSourceProject'] ?? '開源專案';
  String get tatSourceCode => _localizedValues[locale.languageCode]?['tatSourceCode'] ?? 'TAT 2 原始碼';
  String get forEducationalUseOnly => _localizedValues[locale.languageCode]?['forEducationalUseOnly'] ?? '僅供學習交流使用';
  String get coreFeatureReference => _localizedValues[locale.languageCode]?['coreFeatureReference'] ?? '北科課表 APP 核心技術參考';
  String get webCrawlerReference => _localizedValues[locale.languageCode]?['webCrawlerReference'] ?? '北科課程爬蟲與網頁版參考';
  
  // 登入相關
  String get guestMode => _localizedValues[locale.languageCode]?['guestMode'] ?? '訪客模式';
  String featureRequiresLogin(String featureName) => _localizedValues[locale.languageCode]?['featureRequiresLogin']?.replaceAll('%s', featureName) ?? '$featureName需要登入後才能使用';
  String get loginToUpdate => _localizedValues[locale.languageCode]?['loginToUpdate'] ?? '登入更新';
  String get cachedData => _localizedValues[locale.languageCode]?['cachedData'] ?? '緩存資料';
  String get pleaseLoginFirst => _localizedValues[locale.languageCode]?['pleaseLoginFirst'] ?? '請先登入';
  String get loginTimeout => _localizedValues[locale.languageCode]?['loginTimeout'] ?? '登入逾時';
  String get pleaseRelogin => _localizedValues[locale.languageCode]?['pleaseRelogin'] ?? '請重新登入';
  String get connectionInterrupted => _localizedValues[locale.languageCode]?['connectionInterrupted'] ?? '中斷連線';
  String get loginSuccess => _localizedValues[locale.languageCode]?['loginSuccess'] ?? '登入成功';
  String get unknownError => _localizedValues[locale.languageCode]?['unknownError'] ?? '未知錯誤';
  
  // 課程查詢頁面專用
  String get categoryFilter => _localizedValues[locale.languageCode]?['categoryFilter'] ?? '博雅類別';
  String get timeFilter => _localizedValues[locale.languageCode]?['timeFilter'] ?? '時間篩選';
  String get collegeFilter => _localizedValues[locale.languageCode]?['collegeFilter'] ?? '學院篩選';
  String get classQuery => _localizedValues[locale.languageCode]?['classQuery'] ?? '班級查詢';
  String get clearFilters => _localizedValues[locale.languageCode]?['clearFilters'] ?? '清除篩選';
  String get excludeConflicts => _localizedValues[locale.languageCode]?['excludeConflicts'] ?? '不選衝堂';
  String get selectCategories => _localizedValues[locale.languageCode]?['selectCategories'] ?? '選擇一個或多個博雅類別';
  String get userCourseTableNotFound => _localizedValues[locale.languageCode]?['userCourseTableNotFound'] ?? '沒有找到用戶課表';
  String loadedCourses(int count) => _localizedValues[locale.languageCode]?['loadedCourses']?.replaceAll('%d', count.toString()) ?? '已載入 %d 筆課程';
  String removedConflicts(int count) => _localizedValues[locale.languageCode]?['removedConflicts']?.replaceAll('%d', count.toString()) ?? '已取消選取 %d 個衝堂時段';
  String loadFailedWithMsg(String error) => _localizedValues[locale.languageCode]?['loadFailedWithMsg']?.replaceAll('%s', error) ?? '載入失敗：%s';
  String get selectClassOrProgramTitle => _localizedValues[locale.languageCode]?['selectClassOrProgramTitle'] ?? '選擇班級或學程';
  String get searchProgramName => _localizedValues[locale.languageCode]?['searchProgramName'] ?? '搜尋學程名稱';
  String coursesCount(int count) => _localizedValues[locale.languageCode]?['coursesCount']?.replaceAll('%d', count.toString()) ?? '$count 門課程';
  String noCourseData2(String name) => _localizedValues[locale.languageCode]?['noCourseData2']?.replaceAll('%s', name) ?? '$name 沒有開課資料';
  
  // 通知設定相關
  String get badgeNotification => _localizedValues[locale.languageCode]?['badgeNotification'] ?? '紅點通知';
  String get autoCheckEnabled => _localizedValues[locale.languageCode]?['autoCheckEnabled'] ?? '已啟用自動檢查';
  String get autoCheckDisabled => _localizedValues[locale.languageCode]?['autoCheckDisabled'] ?? '已關閉自動檢查';
  String get showAllBadges => _localizedValues[locale.languageCode]?['showAllBadges'] ?? '已顯示所有紅點';
  String get hiddenAllBadges => _localizedValues[locale.languageCode]?['hiddenAllBadges'] ?? '已隱藏所有紅點';
  
  // i學院檔案相關
  String loadFilesError(String error) => _localizedValues[locale.languageCode]?['loadFilesError']?.replaceAll('%s', error) ?? '載入檔案列表時發生錯誤：$error';

  // 空教室查詢頁面
  String get allBuildings => _localizedValues[locale.languageCode]?['allBuildings'] ?? '全部大樓';
  String get selectFloor => _localizedValues[locale.languageCode]?['selectFloor'] ?? '選擇樓層';
  String get allFloors => _localizedValues[locale.languageCode]?['allFloors'] ?? '全部樓層';
  String floorNumber(int floor) => _localizedValues[locale.languageCode]?['floorNumber']?.replaceAll('%d', floor.toString()) ?? '$floor樓';
  String get queryFailed => _localizedValues[locale.languageCode]?['queryFailed'] ?? '查詢失敗，請稍後再試';
  String errorOccurred(String error) => _localizedValues[locale.languageCode]?['errorOccurred']?.replaceAll('%s', error) ?? '發生錯誤: $error';
  String foundClassrooms(int count) => _localizedValues[locale.languageCode]?['foundClassrooms']?.replaceAll('%d', count.toString()) ?? '找到 $count 間教室';
  String get periodSchedule => _localizedValues[locale.languageCode]?['periodSchedule'] ?? '時段一覽';
  String get freeTime => _localizedValues[locale.languageCode]?['freeTime'] ?? '空堂';
  String get busyTime => _localizedValues[locale.languageCode]?['busyTime'] ?? '有課';
  String get noClassroomData => _localizedValues[locale.languageCode]?['noClassroomData'] ?? '目前沒有空教室資料';
  String get switchOtherDay => _localizedValues[locale.languageCode]?['switchOtherDay'] ?? '可以切換其他星期查看';
  String get noMatchingClassrooms => _localizedValues[locale.languageCode]?['noMatchingClassrooms'] ?? '沒有符合條件的空教室';
  String get adjustFilters => _localizedValues[locale.languageCode]?['adjustFilters'] ?? '試試調整篩選條件';
  
  // 課程查詢頁面專用 - 新增
  String get selectOneOrMoreCategories => _localizedValues[locale.languageCode]?['selectOneOrMoreCategories'] ?? '選擇一個或多個博雅類別';
  String get selectOneCollege => _localizedValues[locale.languageCode]?['selectOneCollege'] ?? '選擇一個學院';
  String get searching => _localizedValues[locale.languageCode]?['searching'] ?? '搜尋中...';
  String get startSearching => _localizedValues[locale.languageCode]?['startSearching'] ?? '開始搜尋課程';
  String get searchHint => _localizedValues[locale.languageCode]?['searchHint'] ?? '輸入關鍵字或點擊右下角按鈕\n設定篩選條件或選擇班級';
  String get noMatchingCourses => _localizedValues[locale.languageCode]?['noMatchingCourses'] ?? '沒有找到符合的課程';
  String get tryAdjustingFilters => _localizedValues[locale.languageCode]?['tryAdjustingFilters'] ?? '試試調整搜尋條件或篩選器';
  String coursesFound(int count) => _localizedValues[locale.languageCode]?['coursesFound']?.replaceAll('%d', count.toString()) ?? '找到 $count 筆課程';
  String get deselectConflicts => _localizedValues[locale.languageCode]?['deselectConflicts'] ?? '不選衝堂';
  String get noUserCourseTable => _localizedValues[locale.languageCode]?['noUserCourseTable'] ?? '沒有找到用戶課表';
  String deselectedConflicts(int count) => _localizedValues[locale.languageCode]?['deselectedConflicts']?.replaceAll('%d', count.toString()) ?? '已取消選取 $count 個衝堂時段';
  String get firstPage => _localizedValues[locale.languageCode]?['firstPage'] ?? '第一頁';
  String get previousPage => _localizedValues[locale.languageCode]?['previousPage'] ?? '上一頁';
  String get nextPage => _localizedValues[locale.languageCode]?['nextPage'] ?? '下一頁';
  String get lastPage => _localizedValues[locale.languageCode]?['lastPage'] ?? '最後一頁';
  String creditValue(String credit) => _localizedValues[locale.languageCode]?['creditValue']?.replaceAll('%s', credit) ?? '$credit 學分';
  String hourValue(String hour) => _localizedValues[locale.languageCode]?['hourValue']?.replaceAll('%s', hour) ?? '$hour 小時';
  String loadedClassCourses(String title, int count) {
    final template = _localizedValues[locale.languageCode]?['loadedClassCourses'] ?? '已載入 %t 的課程 (%d 筆)';
    return template.replaceAll('%t', title).replaceAll('%d', count.toString());
  }

  // 本地化資料
  static const Map<String, Map<String, String>> _localizedValues = {
    'zh': {
      'appName': 'QAQ 北科生活',
      'appTitle': 'TAT 北科生活',
      'ok': '確定',
      'cancel': '取消',
      'save': '儲存',
      'delete': '刪除',
      'edit': '編輯',
      'close': '關閉',
      'search': '搜尋',
      'add': '新增',
      'remove': '移除',
      'loading': '載入中...',
      'error': '錯誤',
      'success': '成功',
      'confirm': '確認',
      
      // 導航
      'courseTable': '課表',
      'calendar': '日曆',
      'courseSearch': '課程查詢',
      'grades': '成績',
      'credits': '學分',
      'campusMap': '校園地圖',
      'emptyClassroom': '空教室查詢',
      'clubAnnouncements': '社團公告',
      'personalization': '個人化',
      'adminSystem': '校務系統',
      'messages': '訊息',
      'ntutLearn': '北科i學園',
      'foodMap': '美食地圖',
      'other': '其他',
      
      // 個人化
      'themeSettings': '配色設定',
      'themeMode': '主題模式',
      'language': '語言',
      'followSystem': '跟隨系統',
      'lightMode': '淺色模式',
      'darkMode': '深色模式',
      'courseSettings': '課程設定',
      'courseColor': '課程顏色',
      'courseColorHint': '長按課表中的課程即可自訂顏色',
      
      // 個人化介紹彈窗
      'welcomeToPersonalization': '歡迎來到個人化設定',
      'personalizationIntro': '這裡可以自訂 App 的外觀與體驗：',
      'themeColorOption': '主題顏色',
      'themeColorDesc': '選擇你喜歡的主題色調',
      'themeModeOption': '深淺模式',
      'themeModeDesc': '切換亮色或暗色主題',
      'languageOption': '語言設定',
      'languageDesc': '支援繁體中文和英文',
      'courseTableStyleOption': '課表風格',
      'courseTableStyleDesc': '選擇喜歡的課表顯示方式',
      'courseColorStyleOption': '課程配色',
      'courseColorStyleDesc': '自訂課表的配色方案',
      'longPressCourseTip': '長按課表中的課程可以自訂顏色喔！',
      'startExploring': '開始探索',
      
      // 課表風格
      'courseTableStyle': '課表風格',
      'selectCourseTableStyle': '選擇課表風格',
      'material3Style': 'Material 3 風格',
      'material3StyleDesc': '懸浮卡片設計，現代化視覺',
      'classicStyle': '經典風格',
      'classicStyleDesc': '表格式佈局，緊湊簡潔',
      'tatStyle': 'TAT 傳統風格',
      'tatStyleDesc': '緊湊表格，馬卡龍色系',
      'switchedToMaterial3': '已切換至 Material 3 風格課表',
      'switchedToClassic': '已切換至經典風格課表',
      'switchedToTat': '已切換至 TAT 傳統風格課表',
      
      // 課程配色
      'courseColorStyle': '課程配色',
      'selectCourseColorStyle': '選擇課程配色',
      'tatColorStyle': 'TAT 配色',
      'tatColorStyleDesc': '柔和的馬卡龍色系',
      'themeColorStyle': '主題配色',
      'themeColorStyleDesc': '根據主題色生成',
      'rainbowColorStyle': '彩虹配色',
      'rainbowColorStyleDesc': '經典彩虹色系',
      'switchedToTatColor': '已切換至 TAT 配色',
      'switchedToThemeColor': '已切換至主題配色',
      'switchedToRainbowColor': '已切換至彩虹配色',
      
      // 課程顏色說明
      'courseColorInfo': '課程顏色說明',
      'customYourCourseTable': '訂製屬於你自己的課表',
      'tatMacaronColor': 'TAT 馬卡龍配色',
      'tatMacaronColorDesc': '柔和的粉彩色系，提供 13 種精選顏色：',
      'themeDynamicColor': '主題動態配色',
      'themeDynamicColorDesc': '根據您的主題色生成 16 種和諧配色：',
      'rainbowColor': '彩虹色系配色',
      'rainbowColorDesc': '經典的彩虹色譜，提供 16 種鮮明顏色：',
      'softMacaronTone': '柔和的馬卡龍色調',
      'eyeFriendlyLightColor': '保護眼睛的淺色系',
      'highRecognitionColor': '高辨識度的色彩搭配',
      'blendWithTheme': '與主題色完美融合',
      'warmColdGradient': '冷暖色調漸變搭配',
      'autoAdaptMode': '自動適配亮暗模式',
      'evenHueDistribution': '色相均勻分布',
      'maxRecognition': '最大化辨識度',
      'independentOfTheme': '獨立於主題色',
      'longPressToCustomColor': '長按課表中的任一課程\n即可自訂專屬顏色',
      'gotIt': '我知道了',
      
      // 重新分配顏色
      'reassignColors': '重新隨機分配顏色',
      'reassignColorsDesc': '清除所有自訂顏色，重新自動分配',
      'reassignColorsConfirm': '重新隨機分配顏色',
      'thisWillDo': '此操作將：',
      'clearAllCustomColors': '清除所有自訂顏色',
      'reassignCourseColors': '重新自動分配課程顏色',
      'useColorSystem': '使用 %s',
      'cannotUndo': '此操作無法復原',
      'tatMacaronColorSystem': 'TAT 馬卡龍色系',
      'themeGradientColorSystem': '主題漸變色系',
      'rainbowColorSystem': '彩虹色系',
      'reassignedWithSystem': '已使用 %s 重新分配課程顏色',
      
      // 設定
      'settings': '設定',
      'customNavBar': '自訂導航欄',
      'customNavBarHint': '選擇常用功能顯示在導航欄',
      'about': '關於我們',
      'aboutHint': '應用程式資訊與版本',
      'feedback': '意見反饋',
      'feedbackHint': '提供建議或回報問題',
      'relogin': '重新登入',
      'reloginHint': '重新登入學校帳號',
      'reloginConfirm': '將清除當前登入狀態並跳轉到登入頁面',
      'logout': '登出',
      'logoutConfirm': '確定要登出嗎？',
      'account': '帳號',
      
      // 導航配置
      'navConfigTitle': '導航列設定',
      'customNavBarTitle': '自訂底部導航列',
      'customNavBarDesc': '點擊項目更換功能，長按可拖曳排序',
      'selectedCount': '已選擇',
      'resetToDefault': '重設為預設',
      'selectFunction': '選擇功能',
      'addFunction': '選擇要新增的功能',
      'unsavedChanges': '未儲存的變更',
      'unsavedChangesDesc': '您有未儲存的設定，確定要離開嗎？',
      'leave': '離開',
      'settingsSaved': '設定已儲存，重啟 App 後生效',
      
      // 主題對話框
      'selectThemeMode': '選擇主題模式',
      'followSystemDesc': '自動切換淺色/深色模式',
      'lightModeDesc': '使用淺色背景主題',
      'darkModeDesc': '使用深色背景主題',
      
      // 語言對話框
      'selectLanguage': '選擇語言',
      'followSystemLang': '使用系統預設語言',
      'traditionalChinese': '繁體中文',
      'english': 'English',
      
      // 其他
      'system': '系統',
      'otherFeatures': '更多功能',
      'confirmLogout': '確認登出',
      'maxNavItems': '最多只能設定 5 個導航項目',
      'noMoreFunctions': '沒有更多功能可以新增',
      'minOneNavItem': '至少需要保留一個導航項目',
      'hint': '提示',
      'position': '位置',
      'fixed': '固定',
      'navConfigHint1': '可自訂 1-5 個導航項目，最多 6 個（含「其他」）',
      'navConfigHint2': '預設導航列為：課表、日曆、課程查詢、成績',
      'navConfigHint3': '長按項目可拖曳調整順序',
      'navConfigHint4': '未加入導航列的功能會顯示在「其他」頁面',
      'navConfigHint5': '儲存後 App 會自動關閉，請重新開啟以套用配置',
      'appWillCloseMessage': '設定已儲存，App 即將關閉以套用新配置',
      
      // 星期
      'monday': '星期一',
      'tuesday': '星期二',
      'wednesday': '星期三',
      'thursday': '星期四',
      'friday': '星期五',
      'saturday': '星期六',
      'sunday': '星期日',
      
      // 課程詳情
      'basicInfo': '基本資訊',
      'courseId': '課號',
      'credit': '學分',
      'hours': '時數',
      'courseStandard': '課程標準',
      'people': '人數',
      'withdraw': '退選',
      'teachingLanguage': '授課語言',
      'teachers': '授課教師',
      'classes': '開課班級',
      'timeAndLocation': '上課時間與地點',
      'courseDescription': '課程概述',
      'evaluationRules': '評分規則',
      'notes': '備註',
      'unknownTeacher': '未知教師',
      'noScorePolicy': '此教師未提供評分規則',
      'noCourseOutline': '此課程目前無課程大綱資訊',
      
      // 成績
      'courseName': '課程名稱',
      'grade': '成績',
      
      // 校務系統
      'cannotLoadAdminSystem': '無法載入校務系統',
      'noAvailableSystems': '沒有可用的系統',
      
      // 星期簡寫
      'monShort': '週一',
      'tueShort': '週二',
      'wedShort': '週三',
      'thuShort': '週四',
      'friShort': '週五',
      'satShort': '週六',
      'sunShort': '週日',
      
      // 單字符星期
      'mon': '一',
      'tue': '二',
      'wed': '三',
      'thu': '四',
      'fri': '五',
      'sat': '六',
      'sun': '日',
      
      // 時間格式化
      'justNow': '剛剛',
      'minutesAgo': '分鐘前',
      'hoursAgo': '小時前',
      'daysAgo': '天前',
      'updated': '更新',
      'justUpdated': '剛剛更新',
      
      // 日期格式
      'dateFormatWithWeekday': 'yyyy年MM月dd日 (E)',
      
      // 日曆頁面
      'backToToday': '回到今天',
      'reload': '重新載入',
      'addEvent': '新增事件',
      'noEventsOnThisDay': '這天沒有事件',
      'loadFailed': '載入失敗',
      'retry': '重試',
      'time': '時間',
      'date': '日期',
      'location': '地點',
      'description': '說明',
      'confirmDelete': '確認刪除',
      'confirmDeleteEvent': '確定要刪除「%s」嗎？',
      'eventDeleted': '事件已刪除',
      'deleteFailed': '刪除失敗：%s',
      'eventAdded': '事件已新增',
      'addFailed': '新增失敗：%s',
      'eventUpdated': '事件已更新',
      'updateFailed': '更新失敗：%s',
      
      // 課表頁面
      'noCourseData': '沒有課程數據，無法設為小工具',
      'generatingWidget': '正在生成小工具...',
      'widgetUpdated': '小工具已更新！請到桌面查看',
      'widgetUpdateFailed': '設為小工具失敗: %s',
      'cannotGetSemesterList': '無法獲取可用學期列表',
      'cannotGetSemesterListRetry': '無法獲取學期列表，請稍後重試',
      'updateFailedUseCached': '更新失敗，使用緩存的學期列表',
      'loadSemesterFailed': '載入學期列表失敗: %s',
      'loadFailed2': '載入失敗: %s',
      'needLoginForLatest': '需要登入才能獲取最新課表',
      'updateFailedShowCached': '更新失敗,顯示緩存數據',
      'updateFailedMsg': '更新失敗:%s',
      'needLogin': '需要登入',
      'needLoginForCourseDesc': '獲取最新課表需要登入。您可以選擇登入或繼續使用離線模式。',
      'loginLater': '稍後登入',
      'loginNow': '立即登入',
      'courseIdWithValue': '課號：%s',
      'creditsAndHours': '學分：%c / 時數：%h',
      'instructor': '教師：%s',
      'classroom': '教室：%s',
      'scheduleTime': '時間：%s',
      'courseType': '修別：%s',
      'viewSyllabus': '查看大綱',
      'noSyllabus': '此課程無課程大綱資料',
      'selectSemester': '選擇學期',
      'moreFeatures': '更多功能',
      'refetchingCourseTable': '重新取得課表中...',
      'refetchingSemesterList': '重新取得學期列表中...',
      'setAsDesktopWidget': '設為桌面小工具',
      'refreshCourseTable': '刷新課表',
      'refreshSemesterList': '刷新學期列表',
      'courseTableFeatureName': '課表',
      'courseTableLoginDesc': '查看課表需要登入\n登入後系統會自動緩存課表數據',
      'iSchoolLoginDesc': '訪客模式無法使用 i學園\n這是在線功能，需要登入後才能查看課程公告、下載教材',
      'announcementCache': '公告快取：%s',
      'downloadFiles': '下載檔案：%s',
      'total': '總計：%s',
      'noCoursesCurrently': '目前沒有課程',
      'lunchBreak': '午休',
      'selectCourseColor': '選擇課程顏色',
      
      // 登入頁面
      'studentId': '學號',
      'pleaseEnterStudentId': '請輸入學號',
      'password': '密碼',
      'pleaseEnterPassword': '請輸入密碼',
      'login': '登入',
      'browseAsGuest': '以訪客模式瀏覽',
      'agreeToTerms': '我已閱讀並同意',
      'privacyPolicy': '隱私權條款',
      'and': '和',
      'termsOfService': '使用者條款',
      'pleaseAgreeToTerms': '請先同意隱私權條款和使用者條款',
      'loginFailed': '登入失敗',
      'loginFailedWithError': '登入失敗：%s',
      'guestModeActivated': '已進入訪客模式，可查看緩存資料',
      
      // 主題顏色名稱
      'colorBlue': '藍色',
      'colorPurple': '紫色',
      'colorGreen': '綠色',
      'colorOrange': '橙色',
      'colorRed': '紅色',
      'colorPink': '粉紅',
      'colorTeal': '青綠',
      'colorIndigo': '靛藍',
      'colorYellow': '黃色',
      
      // 通用動作詞
      'reset': '重置',
      'complete': '完成',
      'done': '完成',
      'open': '開啟',
      'share': '分享',
      'download': '下載',
      'downloaded': '已下載',
      
      // 事件相關
      'allDayEvent': '全天事件',
      'endTimeBeforeStart': '結束時間不能早於開始時間',
      'editEvent': '編輯事件',
      'title': '標題',
      'titleRequired': '標題 *',
      'pleaseEnterTitle': '請輸入標題',
      'moreOptions': '更多選項',
      'color': '顏色',
      'startTime': '開始時間',
      'endTime': '結束時間',
      'notSet': '未設定',
      'recurrence': '重複',
      'noRecurrence': '不重複',
      'daily': '每天',
      'weekly': '每週',
      'monthly': '每月',
      'yearly': '每年',
      'selectEndDateOptional': '選擇結束日期（選填）',
      'endOn': '結束於：%s',
      
      // 通知設定
      'notificationSettings': '通知設定',
      'hideAllBadges': '隱藏所有紅點',
      'hideAllBadgesDesc': '隱藏 App 中的所有紅點通知',
      'autoCheckAnnouncements': '自動檢查公告',
      'autoCheckAnnouncementsDesc': '登入時自動檢查新公告',
      'manageNotificationSettings': '管理紅點通知與自動檢查',
      
      // 重新登入相關
      'reloginUsingSaved': '使用儲存的帳號密碼重新登入',
      'reloggingIn': '重新登入中...',
      'reloginSuccess': '重新登入成功',
      'reloginFailed': '重新登入失敗，請檢查網路連線或帳號密碼',
      'noSavedCredentials': '沒有保存的帳號密碼，請前往登入',
      'reloginFailedWithError': '重新登入失敗: %s',
      'cannotOpenFeedback': '無法開啟反饋頁面',
      'cannotOpenFeedbackWithError': '無法開啟反饋頁面: %s',
      
      // 北科i學院相關
      'clearISchoolData': '清除 i學院 資料',
      'thisWillClear': '這將會清除：',
      'clearing': '清除中...',
      'allISchoolDataCleared': '已清除所有 i學院 資料',
      'clearFailedWithError': '清除失敗：%s',
      'allISchoolBadgesCleared': '已清除所有 i學院 紅點',
      'clearBadgesFailedWithError': '清除紅點失敗：%s',
      'markFailedWithError': '標記失敗：%s',
      'clearCacheAndFiles': '清除快取與檔案',
      'markAllAsRead': '標記全部已讀',
      'markAllAsUnread': '標記全部未讀',
      'loadingCourses': '載入課程中...',
      'noCoursesFound': '沒有找到課程',
      'reloadCourses': '重新載入',
      'courseAnnouncements': '課程公告',
      'courseMaterials': '課程教材',
      
      // 文件操作相關
      'confirmToOpen': '確定要打開嗎？',
      'externalLink': '這是一個外部連結',
      'classRecording': '上課錄影',
      'classRecordingWarning': '注意：影片可能會載入失敗，若失敗請重試或使用瀏覽器開啟',
      'downloadStarted': '開始下載：%s',
      'downloadCompleted': '下載完成：%s',
      'downloadFailedWithError': '下載失敗：%s',
      'openFileFailedWithError': '開啟檔案失敗：%s',
      'shareFailedWithError': '分享失敗：%s',
      'fileDeleted': '已刪除：%s',
      'deleteFailedWithError': '刪除失敗：%s',
      'deleteFile': '刪除檔案',
      'confirmDeleteFile': '確定要刪除「%s」嗎？',
      'openedInBrowser': '已在瀏覽器中開啟',
      'cannotAutoOpenBrowser': '無法自動開啟瀏覽器，已複製網址',
      'copiedToClipboard': '已複製到剪貼簿',
      'copyFailedWithError': '複製失敗：%s',
      'errorWithValue': '錯誤:%s',
      'loadCourseFailedWithError': '載入課程失敗：%s',
      'cannotOpenLink': '無法開啟連結：%s',
      'openLinkFailedWithError': '開啟連結失敗：%s',
      'noAnnouncementContent': '無公告內容',
      
      // 公告列表頁面
      'loginISchoolFailed': '登入 i學院失敗，請稍後再試',
      'noCourseAnnouncements': '此課程目前沒有公告',
      'loadAnnouncementsFailed': '載入公告失敗，請稍後再試',
      'loadAnnouncementDetailFailed': '載入公告詳情時發生錯誤',
      'loadAnnouncementDetailFailedWithError': '載入公告詳情時發生錯誤：%s',
      'cannotLoadAnnouncementDetail': '無法載入公告詳情',
      'cannotGetLatestAnnouncementContent': '無法獲取最新的公告內容',
      'cannotFindAttachment': '找不到附件：%s',
      'downloadCompletedWithFileName': '下載完成：%s',
      'fileNotFound': '檔案不存在',
      'openFileFailed': '開啟檔案失敗',
      'noAppToOpenFile': '沒有可開啟此檔案的應用程式',
      'fileNotFoundError': '找不到檔案',
      'permissionDenied': '權限被拒絕',
      'openFileErrorWithMessage': '開啟檔案時發生錯誤：%s',
      'downloaded_clickToOpen': '已下載 · 點擊開啟',
      'clickToDownload': '點擊下載',
      
      // 選擇器相關
      'classCategory': '班級',
      'microProgram': '微學程',
      'loadCollegeStructureFailed': '載入學院結構失敗',
      'loadMicroProgramsFailed': '載入微學程列表失敗',
      'pleaseSelectCollege': '請選擇學院',
      'pleaseSelectCollegeFirst': '請先選擇學院',
      
      // 成績與學分相關
      'noGradeData': '沒有成績資料',
      'noData': '暫無資料',
      'pleaseSetGraduationStandard': '請先設定畢業標準',
      'setGraduationStandard': '設定畢業標準',
      'graduationStandardSettings': '畢業學分標準設定',
      'liberalArtsCreditsDetail': '博雅學分詳情',
      'nonDepartmentCredits': '外系學分',
      
      // 課程大綱相關
      'loadingSyllabus': '載入課程大綱中...',
      'goToLogin': '前往登入',
      'noSyllabusData': '無課程大綱資料',
      'courseSyllabus': '課程大綱',
      'courseObjective': '課程目標',
      'courseOutline': '課程大綱',
      'teacherContactInfo': '老師聯絡資訊',
      'textbooks': '教科書',
      'referenceBooks': '參考書目',
      'gradingMethod': '評量方式',
      'gradingStandard': '評量標準',
      
      // 課程查詢相關
      'courseSearchPlaceholder': '課程名稱、教師、課號',
      'teacher': '教師',
      'teacherName': '授課教師',
      'classTime': '上課時間',
      'classTimeAndPlace': '上課時間與地點',
      'required': '必修',
      'elective': '選修',
      'generalEducation': '通識',
      'liberalArts': '博雅',
      'department': '系所',
      'professional': '專業',
      'common': '共同',
      
      // 成績相關
      'overallStats': '整體統計',
      'semesterGrades': '學期成績',
      'averageScore': '平均成績',
      'performanceScore': '操行成績',
      'takenCredits': '修習學分',
      'obtainedCredits': '獲得學分',
      'gpa': '學期平均',
      'overallGpa': '總平均',
      'rank': '排名',
      'overallRank': '總排名',
      'classRank': '班排',
      'departmentRank': '系排',
      'classRankFull': '班排名',
      'departmentRankFull': '系排名',
      'topPercentage': '前 %p%',
      'totalStudents': '總人數',
      'earnedCredits': '取得學分',
      'failedCredits': '未通過學分',
      'totalCredits': '總學分',
      'score': '分數',
      'pass': '通過',
      'fail': '不及格',
      'failedCoursesCount': '%d 門課程不及格',
      'courseCredit': '學分',
      'courseCount': '課程數',
      'midtermScore': '期中成績',
      'finalScore': '期末成績',
      'usualScore': '平時成績',
      'loadGradesFailed': '載入成績失敗',
      'cannotGetStudentId': '無法取得學號',
      'gradesFeatureName': '成績',
      'gradesLoginDesc': '訪客模式無法查看成績\n登入後可查看並緩存成績資料',
      'semesterGradesList': '各學期成績',
      'semesterSummary': '平均: %a | 學分: %e/%t',
      
      // 學分統計相關
      'creditStats': '學分統計',
      'graduationRequirement': '畢業門檻',
      'requiredCredits': '必修學分',
      'electiveCredits': '選修學分',
      'liberalArtsCredits': '博雅學分',
      'professionalRequired': '專業必修',
      'professionalElective': '專業選修',
      'commonRequired': '共同必修',
      'commonElective': '共同選修',
      'freeElective': '自由選修',
      'creditsProgress': '學分進度',
      'remaining': '還需',
      'completed': '已完成',
      'inProgress': '進行中',
      'creditUnit': '%d 學分',
      'minimumGraduationCredits': '最低畢業學分',
      'currentTotalCredits': '目前總學分',
      'creditsNeeded': '還需學分',
      
      // 學院、系所、班級相關
      'college': '學院',
      'selectCollege': '選擇學院',
      'departmentOrProgram': '系所',
      'selectDepartment': '選擇系所',
      'classGrade': '班級',
      'selectClass': '選擇班級',
      'selectClassOrProgram': '選擇班級或學程',
      'program': '學程',
      'gradeLevel': '年級',
      'academicYear': '學年度',
      'openingClass': '開課班級',
      'classInfo': '班級資訊',
      
      // 空教室查詢相關
      'emptyClassroomQuery': '空教室查詢',
      'building': '建築',
      'floor': '樓層',
      'room': '教室',
      'available': '空',
      'occupied': '忙',
      'selectTimeSlot': '選擇時段',
      'selectBuilding': '選擇教學大樓',
      'noEmptyClassrooms': '沒有空教室',
      'searchResults': '搜尋結果',
      
      // 其他通用字串
      'filter': '篩選',
      'sort': '排序',
      'ascending': '升序',
      'descending': '降序',
      'all': '全部',
      'none': '無',
      'selectAll': '全選',
      'deselectAll': '取消全選',
      'apply': '套用',
      'clear': '清除',
      'refresh': '重新整理',
      'more': '更多',
      'less': '較少',
      'detail': '詳情',
      'details': '詳細資訊',
      'information': '資訊',
      'notice': '公告',
      'announcement': '公告',
      'attachment': '附件',
      'attachments': '附件',
      'noAttachments': '無附件',
      'viewDetails': '查看詳情',
      'backToList': '返回列表',
      
      // 關於頁面
      'contributors': '貢獻者',
      'seniorContributors': '元老級貢獻者',
      'specialThanks': '特別感謝',
      'legalInformation': '法律資訊',
      'privacyPolicyTitle': '隱私權條款',
      'privacyPolicyDesc': '了解我們如何保護您的隱私',
      'termsOfServiceTitle': '使用者條款',
      'termsOfServiceDesc': '使用服務前請詳閱本條款',
      'openSourceProject': '開源專案',
      'tatSourceCode': 'TAT 2 原始碼',
      'forEducationalUseOnly': '僅供學習交流使用',
      'coreFeatureReference': '北科課表 APP 核心技術參考',
      'webCrawlerReference': '北科課程爬蟲與網頁版參考',
      
      // 登入相關
      'guestMode': '訪客模式',
      'featureRequiresLogin': '%s需要登入後才能使用',
      'loginToUpdate': '登入更新',
      'cachedData': '緩存資料',
      
      // 課程查詢頁面專用
      'categoryFilter': '博雅類別',
      'timeFilter': '時間篩選',
      'collegeFilter': '學院篩選',
      'classQuery': '班級查詢',
      'clearFilters': '清除篩選',
      'excludeConflicts': '不選衝堂',
      'selectCategories': '選擇一個或多個博雅類別',
      'userCourseTableNotFound': '沒有找到用戶課表',
      'loadedCourses': '已載入 %d 筆課程',
      'removedConflicts': '已取消選取 %d 個衝堂時段',
      'loadFailedWithMsg': '載入失敗：%s',
      'selectClassOrProgramTitle': '選擇班級或學程',
      'searchProgramName': '搜尋學程名稱',
      'coursesCount': '%d 門課程',
      'noCourseData2': '%s 沒有開課資料',
      
      // 通知設定相關
      'badgeNotification': '紅點通知',
      'autoCheckEnabled': '已啟用自動檢查',
      'autoCheckDisabled': '已關閉自動檢查',
      'showAllBadges': '已顯示所有紅點',
      'hiddenAllBadges': '已隱藏所有紅點',
      
      // i學院檔案相關
      'loadFilesError': '載入檔案列表時發生錯誤：%s',
      
      // 空教室查詢頁面
      'allBuildings': '全部大樓',
      'selectFloor': '選擇樓層',
      'allFloors': '全部樓層',
      'floorNumber': '%d樓',
      'queryFailed': '查詢失敗，請稍後再試',
      'errorOccurred': '發生錯誤: %s',
      'foundClassrooms': '找到 %d 間教室',
      'periodSchedule': '時段一覽',
      'freeTime': '空堂',
      'busyTime': '有課',
      'noClassroomData': '目前沒有空教室資料',
      'switchOtherDay': '可以切換其他星期查看',
      'noMatchingClassrooms': '沒有符合條件的空教室',
      'adjustFilters': '試試調整篩選條件',
      
      // 課程查詢頁面專用 - 新增
      'selectOneOrMoreCategories': '選擇一個或多個博雅類別',
      'selectOneCollege': '選擇一個學院',
      'searching': '搜尋中...',
      'startSearching': '開始搜尋課程',
      'searchHint': '輸入關鍵字或點擊右下角按鈕\n設定篩選條件或選擇班級',
      'noMatchingCourses': '沒有找到符合的課程',
      'tryAdjustingFilters': '試試調整搜尋條件或篩選器',
      'coursesFound': '找到 %d 筆課程',
      'deselectConflicts': '不選衝堂',
      'noUserCourseTable': '沒有找到用戶課表',
      'deselectedConflicts': '已取消選取 %d 個衝堂時段',
      'firstPage': '第一頁',
      'previousPage': '上一頁',
      'nextPage': '下一頁',
      'lastPage': '最後一頁',
      'creditValue': '%s 學分',
      'hourValue': '%s 小時',
      'loadedClassCourses': '已載入 %t 的課程 (%d 筆)',
    },
    'en': {
      'appName': 'QAQ NTUT Life',
      'appTitle': 'TAT NTUT Life',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'close': 'Close',
      'search': 'Search',
      'add': 'Add',
      'remove': 'Remove',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'confirm': 'Confirm',
      
      // Navigation
      'courseTable': 'Course',
      'calendar': 'Calendar',
      'courseSearch': 'Search',
      'grades': 'Grades',
      'credits': 'Credits',
      'campusMap': 'Map',
      'emptyClassroom': 'Classroom',
      'clubAnnouncements': 'Announcements',
      'personalization': 'Personalization',
      'adminSystem': 'Info',
      'messages': 'Messages',
      'ntutLearn': 'i-Learn',
      'foodMap': 'Food Map',
      'other': 'Other',
      
      // Personalization
      'themeSettings': 'Theme Settings',
      'themeMode': 'Theme Mode',
      'language': 'Language',
      'followSystem': 'Follow System',
      'lightMode': 'Light Mode',
      'darkMode': 'Dark Mode',
      'courseSettings': 'Course Settings',
      'courseColor': 'Course Color',
      'courseColorHint': 'Long press on course to customize color',
      
      // Personalization Intro Dialog
      'welcomeToPersonalization': 'Welcome to Personalization',
      'personalizationIntro': 'Customize your app appearance and experience:',
      'themeColorOption': 'Theme Color',
      'themeColorDesc': 'Choose your favorite color scheme',
      'themeModeOption': 'Light/Dark Mode',
      'themeModeDesc': 'Switch between light and dark theme',
      'languageOption': 'Language',
      'languageDesc': 'Supports Traditional Chinese and English',
      'courseTableStyleOption': 'Course Table Style',
      'courseTableStyleDesc': 'Choose your preferred display style',
      'courseColorStyleOption': 'Course Color Scheme',
      'courseColorStyleDesc': 'Customize course table colors',
      'longPressCourseTip': 'Long press any course to customize its color!',
      'startExploring': 'Start Exploring',
      
      // Course Table Style
      'courseTableStyle': 'Course Table Style',
      'selectCourseTableStyle': 'Select Course Table Style',
      'material3Style': 'Material 3 Style',
      'material3StyleDesc': 'Floating card design, modern look',
      'classicStyle': 'Classic Style',
      'classicStyleDesc': 'Table layout, compact and clean',
      'tatStyle': 'TAT Classic Style',
      'tatStyleDesc': 'Compact table, macaron colors',
      'switchedToMaterial3': 'Switched to Material 3 style',
      'switchedToClassic': 'Switched to Classic style',
      'switchedToTat': 'Switched to TAT Classic style',
      
      // Course Color Style
      'courseColorStyle': 'Course Color Scheme',
      'selectCourseColorStyle': 'Select Color Scheme',
      'tatColorStyle': 'TAT Colors',
      'tatColorStyleDesc': 'Soft macaron color palette',
      'themeColorStyle': 'Theme Colors',
      'themeColorStyleDesc': 'Generated from theme color',
      'rainbowColorStyle': 'Rainbow Colors',
      'rainbowColorStyleDesc': 'Classic rainbow spectrum',
      'switchedToTatColor': 'Switched to TAT Colors',
      'switchedToThemeColor': 'Switched to Theme Colors',
      'switchedToRainbowColor': 'Switched to Rainbow Colors',
      
      // Course Color Info
      'courseColorInfo': 'Course Color Information',
      'customYourCourseTable': 'Customize your course table',
      'tatMacaronColor': 'TAT Macaron Colors',
      'tatMacaronColorDesc': 'Soft pastel palette with 13 selected colors:',
      'themeDynamicColor': 'Theme Dynamic Colors',
      'themeDynamicColorDesc': 'Generated 16 harmonious colors from your theme:',
      'rainbowColor': 'Rainbow Spectrum Colors',
      'rainbowColorDesc': 'Classic rainbow spectrum with 16 vibrant colors:',
      'softMacaronTone': 'Soft macaron tones',
      'eyeFriendlyLightColor': 'Eye-friendly light colors',
      'highRecognitionColor': 'High recognition color matching',
      'blendWithTheme': 'Perfect blend with theme',
      'warmColdGradient': 'Warm-cold gradient matching',
      'autoAdaptMode': 'Auto-adapt to light/dark mode',
      'evenHueDistribution': 'Even hue distribution',
      'maxRecognition': 'Maximum recognition',
      'independentOfTheme': 'Independent of theme color',
      'longPressToCustomColor': 'Long press any course\nto customize its color',
      'gotIt': 'Got It',
      
      // Reassign Colors
      'reassignColors': 'Reassign All Colors',
      'reassignColorsDesc': 'Clear custom colors and auto-assign',
      'reassignColorsConfirm': 'Reassign All Colors',
      'thisWillDo': 'This will:',
      'clearAllCustomColors': 'Clear all custom colors',
      'reassignCourseColors': 'Auto-assign course colors',
      'useColorSystem': 'Use %s',
      'cannotUndo': 'This cannot be undone',
      'tatMacaronColorSystem': 'TAT Macaron Colors',
      'themeGradientColorSystem': 'Theme Gradient Colors',
      'rainbowColorSystem': 'Rainbow Colors',
      'reassignedWithSystem': 'Reassigned colors with %s',
      
      // Settings
      'settings': 'Settings',
      'customNavBar': 'Custom Navigation Bar',
      'customNavBarHint': 'Select frequently used functions for navigation bar',
      'about': 'About',
      'aboutHint': 'App information and version',
      'feedback': 'Feedback',
      'feedbackHint': 'Provide suggestions or report issues',
      'relogin': 'Re-login',
      'reloginHint': 'Re-login to school account',
      'reloginConfirm': 'This will clear the current login status and redirect to login page',
      'logout': 'Logout',
      'logoutConfirm': 'Are you sure you want to logout?',
      'account': 'Account',
      
      // Navigation Config
      'navConfigTitle': 'Navigation Settings',
      'customNavBarTitle': 'Custom Bottom Navigation',
      'customNavBarDesc': 'Tap to change function, long press to reorder',
      'selectedCount': 'Selected',
      'resetToDefault': 'Reset to Default',
      'selectFunction': 'Select Function',
      'addFunction': 'Select Function to Add',
      'unsavedChanges': 'Unsaved Changes',
      'unsavedChangesDesc': 'You have unsaved settings. Are you sure you want to leave?',
      'leave': 'Leave',
      'settingsSaved': 'Settings saved, restart app to take effect',
      
      // Theme Dialog
      'selectThemeMode': 'Select Theme Mode',
      'followSystemDesc': 'Auto switch light/dark mode',
      'lightModeDesc': 'Use light background theme',
      'darkModeDesc': 'Use dark background theme',
      
      // Language Dialog
      'selectLanguage': 'Select Language',
      'followSystemLang': 'Use system default language',
      'traditionalChinese': '繁體中文',
      'english': 'English',
      
      // Other
      'system': 'System',
      'otherFeatures': 'More Features',
      'confirmLogout': 'Confirm Logout',
      'maxNavItems': 'Maximum 5 navigation items',
      'noMoreFunctions': 'No more functions to add',
      'minOneNavItem': 'At least one navigation item required',
      'hint': 'Hint',
      'position': 'Position',
      'fixed': 'Fixed',
      'navConfigHint1': 'Customize 1-5 navigation items, up to 6 (including "Other")',
      'navConfigHint2': 'Default navigation: Course Table, Calendar, Course Search, Grades',
      'navConfigHint3': 'Long press to drag and reorder items',
      'navConfigHint4': 'Functions not in navigation bar will appear in "Other" page',
      'navConfigHint5': 'App will restart after saving to apply configuration',
      'appWillCloseMessage': 'Settings saved, app will restart to apply new configuration',
      
      // 星期
      'monday': 'Monday',
      'tuesday': 'Tuesday',
      'wednesday': 'Wednesday',
      'thursday': 'Thursday',
      'friday': 'Friday',
      'saturday': 'Saturday',
      'sunday': 'Sunday',
      
      // Course Details
      'basicInfo': 'Basic Info',
      'courseId': 'Course ID',
      'credit': 'Credit',
      'hours': 'Hours',
      'courseStandard': 'Course Standard',
      'people': 'People',
      'withdraw': 'Withdraw',
      'teachingLanguage': 'Teaching Language',
      'teachers': 'Instructors',
      'classes': 'Classes',
      'timeAndLocation': 'Time & Location',
      'courseDescription': 'Course Description',
      'evaluationRules': 'Evaluation Rules',
      'notes': 'Notes',
      'unknownTeacher': 'Unknown Teacher',
      'noScorePolicy': 'This instructor has not provided evaluation rules',
      'noCourseOutline': 'No course outline information available',
      
      // Grades
      'courseName': 'Course Name',
      'grade': 'Grade',
      
      // Admin System
      'cannotLoadAdminSystem': 'Cannot load admin system',
      'noAvailableSystems': 'No available systems',
      
      // 星期簡寫
      'monShort': 'Mon',
      'tueShort': 'Tue',
      'wedShort': 'Wed',
      'thuShort': 'Thu',
      'friShort': 'Fri',
      'satShort': 'Sat',
      'sunShort': 'Sun',
      
      // 單字符星期
      'mon': 'M',
      'tue': 'T',
      'wed': 'W',
      'thu': 'R',
      'fri': 'F',
      'sat': 'S',
      'sun': 'U',
      
      // 時間格式化
      'justNow': 'Just now',
      'minutesAgo': 'minutes ago',
      'hoursAgo': 'hours ago',
      'daysAgo': 'days ago',
      'updated': 'updated',
      'justUpdated': 'Just updated',
      
      // Date Format
      'dateFormatWithWeekday': 'MMM dd, yyyy (E)',
      
      // Calendar Page
      'backToToday': 'Back to Today',
      'reload': 'Reload',
      'addEvent': 'Add Event',
      'noEventsOnThisDay': 'No events on this day',
      'loadFailed': 'Load Failed',
      'retry': 'Retry',
      'time': 'Time',
      'date': 'Date',
      'location': 'Location',
      'description': 'Description',
      'confirmDelete': 'Confirm Delete',
      'confirmDeleteEvent': 'Are you sure you want to delete "%s"?',
      'eventDeleted': 'Event deleted',
      'deleteFailed': 'Delete failed: %s',
      'eventAdded': 'Event added',
      'addFailed': 'Add failed: %s',
      'eventUpdated': 'Event updated',
      'updateFailed': 'Update failed: %s',
      
      // Course Table Page
      'noCourseData': 'No course data, cannot set as widget',
      'noCoursesCurrently': 'No courses currently',
      'lunchBreak': 'Lunch',
      'selectCourseColor': 'Select Course Color',
      'generatingWidget': 'Generating widget...',
      'widgetUpdated': 'Widget updated! Please check your home screen',
      'widgetUpdateFailed': 'Failed to set widget: %s',
      'cannotGetSemesterList': 'Cannot get available semester list',
      'cannotGetSemesterListRetry': 'Cannot get semester list, please try again later',
      'updateFailedUseCached': 'Update failed, using cached semester list',
      'loadSemesterFailed': 'Failed to load semester list: %s',
      'loadFailed2': 'Load failed: %s',
      'needLoginForLatest': 'Login required to get latest course table',
      'updateFailedShowCached': 'Update failed, showing cached data',
      'updateFailedMsg': 'Update failed: %s',
      'needLogin': 'Login Required',
      'needLoginForCourseDesc': 'Login is required to get the latest course table. You can choose to login or continue in offline mode.',
      'loginLater': 'Login Later',
      'loginNow': 'Login Now',
      'courseIdWithValue': 'Course ID: %s',
      'creditsAndHours': 'Credits: %c / Hours: %h',
      'instructor': 'Instructor: %s',
      'classroom': 'Classroom: %s',
      'scheduleTime': 'Time: %s',
      'courseType': 'Type: %s',
      'viewSyllabus': 'View Syllabus',
      'noSyllabus': 'No syllabus available for this course',
      'selectSemester': 'Select Semester',
      'moreFeatures': 'More Features',
      'refetchingCourseTable': 'Refetching course table...',
      'refetchingSemesterList': 'Refetching semester list...',
      'setAsDesktopWidget': 'Set as Desktop Widget',
      'refreshCourseTable': 'Refresh Course Table',
      'refreshSemesterList': 'Refresh Semester List',
      'courseTableFeatureName': 'Course Table',
      'courseTableLoginDesc': 'Login required to view course table\nCourse table data will be automatically cached after login',
      'iSchoolLoginDesc': 'Cannot use i-Learn in guest mode\nThis is an online feature, login required to view course announcements and download materials',
      'announcementCache': 'Announcement cache: %s',
      'downloadFiles': 'Downloaded files: %s',
      'total': 'Total: %s',
      
      // Login Page
      'studentId': 'Student ID',
      'pleaseEnterStudentId': 'Please enter student ID',
      'password': 'Password',
      'pleaseEnterPassword': 'Please enter password',
      'login': 'Login',
      'browseAsGuest': 'Browse as Guest',
      'agreeToTerms': 'I have read and agree to',
      'privacyPolicy': 'Privacy Policy',
      'and': 'and',
      'termsOfService': 'Terms of Service',
      'pleaseAgreeToTerms': 'Please agree to Privacy Policy and Terms of Service',
      'loginFailed': 'Login Failed',
      'loginFailedWithError': 'Login failed: %s',
      'guestModeActivated': 'Guest mode activated, cached data available',
      
      // 主題顏色名稱
      'colorBlue': 'Blue',
      'colorPurple': 'Purple',
      'colorGreen': 'Green',
      'colorOrange': 'Orange',
      'colorRed': 'Red',
      'colorPink': 'Pink',
      'colorTeal': 'Teal',
      'colorIndigo': 'Indigo',
      'colorYellow': 'Yellow',
      
      // 通用動作詞
      'reset': 'Reset',
      'complete': 'Complete',
      'done': 'Done',
      'open': 'Open',
      'share': 'Share',
      'download': 'Download',
      'downloaded': 'Downloaded',
      
      // 事件相關
      'allDayEvent': 'All Day Event',
      'endTimeBeforeStart': 'End time cannot be earlier than start time',
      'editEvent': 'Edit Event',
      'title': 'Title',
      'titleRequired': 'Title *',
      'pleaseEnterTitle': 'Please enter title',
      'moreOptions': 'More Options',
      'color': 'Color',
      'startTime': 'Start Time',
      'endTime': 'End Time',
      'notSet': 'Not Set',
      'recurrence': 'Recurrence',
      'noRecurrence': 'No Recurrence',
      'daily': 'Daily',
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'yearly': 'Yearly',
      'selectEndDateOptional': 'Select End Date (Optional)',
      'endOn': 'End on: %s',
      
      // 通知設定
      'notificationSettings': 'Notification Settings',
      'hideAllBadges': 'Hide All Badges',
      'hideAllBadgesDesc': 'Hide all badge notifications in the app',
      'autoCheckAnnouncements': 'Auto Check Announcements',
      'autoCheckAnnouncementsDesc': 'Automatically check for new announcements on login',
      'manageNotificationSettings': 'Manage badge notifications and auto-check',
      
      // 重新登入相關
      'reloginUsingSaved': 'Re-login using saved credentials',
      'reloggingIn': 'Re-logging in...',
      'reloginSuccess': 'Re-login successful',
      'reloginFailed': 'Re-login failed, please check network connection or credentials',
      'noSavedCredentials': 'No saved credentials, please login',
      'reloginFailedWithError': 'Re-login failed: %s',
      'cannotOpenFeedback': 'Cannot open feedback page',
      'cannotOpenFeedbackWithError': 'Cannot open feedback page: %s',
      
      // 北科i學院相關
      'clearISchoolData': 'Clear i-Learn Data',
      'thisWillClear': 'This will clear:',
      'clearing': 'Clearing...',
      'allISchoolDataCleared': 'All i-Learn data cleared',
      'clearFailedWithError': 'Clear failed: %s',
      'allISchoolBadgesCleared': 'All i-Learn badges cleared',
      'clearBadgesFailedWithError': 'Clear badges failed: %s',
      'markFailedWithError': 'Mark failed: %s',
      'clearCacheAndFiles': 'Clear Cache and Files',
      'markAllAsRead': 'Mark All as Read',
      'markAllAsUnread': 'Mark All as Unread',
      'loadingCourses': 'Loading courses...',
      'noCoursesFound': 'No courses found',
      'reloadCourses': 'Reload',
      'courseAnnouncements': 'Course Announcements',
      'courseMaterials': 'Course Materials',
      
      // 文件操作相關
      'confirmToOpen': 'Confirm to open?',
      'externalLink': 'This is an external link',
      'classRecording': 'Class Recording',
      'classRecordingWarning': 'Note: Video may fail to load. If it fails, please retry or open in browser',
      'downloadStarted': 'Download started: %s',
      'downloadCompleted': 'Download completed: %s',
      'downloadFailedWithError': 'Download failed: %s',
      'openFileFailedWithError': 'Open file failed: %s',
      'shareFailedWithError': 'Share failed: %s',
      'fileDeleted': 'Deleted: %s',
      'deleteFailedWithError': 'Delete failed: %s',
      'deleteFile': 'Delete File',
      'confirmDeleteFile': 'Are you sure you want to delete "%s"?',
      'openedInBrowser': 'Opened in browser',
      'cannotAutoOpenBrowser': 'Cannot auto-open browser, URL copied',
      'copiedToClipboard': 'Copied to clipboard',
      'copyFailedWithError': 'Copy failed: %s',
      'errorWithValue': 'Error: %s',
      'loadCourseFailedWithError': 'Load course failed: %s',
      'cannotOpenLink': 'Cannot open link: %s',
      'openLinkFailedWithError': 'Open link failed: %s',
      'noAnnouncementContent': 'No announcement content',
      
      // 公告列表頁面
      'loginISchoolFailed': 'Failed to login to i-Learn, please try again later',
      'noCourseAnnouncements': 'This course has no announcements currently',
      'loadAnnouncementsFailed': 'Failed to load announcements, please try again later',
      'loadAnnouncementDetailFailed': 'Error occurred while loading announcement detail',
      'loadAnnouncementDetailFailedWithError': 'Error occurred while loading announcement detail: %s',
      'cannotLoadAnnouncementDetail': 'Cannot load announcement detail',
      'cannotGetLatestAnnouncementContent': 'Cannot get latest announcement content',
      'cannotFindAttachment': 'Cannot find attachment: %s',
      'downloadCompletedWithFileName': 'Download completed: %s',
      'fileNotFound': 'File not found',
      'openFileFailed': 'Failed to open file',
      'noAppToOpenFile': 'No app to open this file',
      'fileNotFoundError': 'File not found',
      'permissionDenied': 'Permission denied',
      'openFileErrorWithMessage': 'Error occurred while opening file: %s',
      'downloaded_clickToOpen': 'Downloaded · Click to open',
      'clickToDownload': 'Click to download',
      
      // 選擇器相關
      'classCategory': 'Class',
      'microProgram': 'Micro Program',
      'loadCollegeStructureFailed': 'Failed to load college structure',
      'loadMicroProgramsFailed': 'Failed to load micro programs',
      'pleaseSelectCollege': 'Please select a college',
      'pleaseSelectCollegeFirst': 'Please select a college first',
      
      // 成績與學分相關
      'noGradeData': 'No grade data',
      'noData': 'No data',
      'pleaseSetGraduationStandard': 'Please set graduation standard first',
      'setGraduationStandard': 'Set Graduation Standard',
      'graduationStandardSettings': 'Graduation Credit Standard Settings',
      'liberalArtsCreditsDetail': 'Liberal Arts Credits Detail',
      'nonDepartmentCredits': 'Non-Department Credits',
      
      // 學分頁面新增
      'graduationSettings': 'Graduation Settings',
      'preparingLoad': 'Preparing to load...',
      'queryingCourseInfo': 'Querying course information... (%c/%t)',
      'loadFailedWith': 'Load failed: %s',
      'creditCalculation': 'Credit Calculation',
      'cannotViewCreditsInGuest': 'Cannot view credits in guest mode\nLogin to view and cache credit data',
      'creditOverview': 'Credit Overview',
      'graduationThreshold': 'Required',
      'stillNeed': 'Need',
      'progress': 'Progress',
      'courseTypeCredits': 'Credits by Course Type',
      'requiredCommonCore': 'Required Common Core',
      'requiredSchoolCore': 'Required School Core',
      'electiveCommon': 'Elective Common',
      'requiredMajorCore': 'Required Major Core',
      'requiredMajorSchool': 'Required Major School',
      'electiveMajor': 'Elective Major',
      'boyaCredits': 'General Education',
      'earned': 'Earned %d',
      'requiredCreditsCount': 'Required %d',
      'boyaDetails': 'General Education Details',
      'dimensionCredits': '%d (%e / %r credits)',
      'freeChoice': 'Free Choice',
      'creditsValue': '%d Credits',
      'otherDepartmentCredits': 'Other Department',
      'earnedMax': 'Earned %e / Max %m',
      
      // 課程大綱相關
      'loadingSyllabus': 'Loading syllabus...',
      'goToLogin': 'Go to Login',
      'noSyllabusData': 'No syllabus data',
      'courseSyllabus': 'Course Syllabus',
      'courseObjective': 'Course Objective',
      'courseOutline': 'Course Outline',
      'teacherContactInfo': 'Teacher Contact Info',
      'textbooks': 'Textbooks',
      'referenceBooks': 'Reference Books',
      'gradingMethod': 'Grading Method',
      'gradingStandard': 'Grading Standard',
      
      // 課程查詢相關
      'courseSearchPlaceholder': 'Course name, teacher, course ID',
      'teacher': 'Teacher',
      'teacherName': 'Instructor',
      'classTime': 'Class Time',
      'classTimeAndPlace': 'Class Time and Location',
      'required': 'Required',
      'elective': 'Elective',
      'generalEducation': 'General Education',
      'liberalArts': 'Liberal Arts',
      'department': 'Department',
      'professional': 'Professional',
      'common': 'Common',
      
      // 成績相關
      'overallStats': 'Overall Statistics',
      'semesterGrades': 'Semester Grades',
      'averageScore': 'Average Score',
      'performanceScore': 'Conduct',
      'takenCredits': 'Taken Credits',
      'obtainedCredits': 'Obtained Credits',
      'gpa': 'Semester GPA',
      'overallGpa': 'Overall GPA',
      'rank': 'Rank',
      'overallRank': 'Overall Rank',
      'classRank': 'Class Rank',
      'departmentRank': 'Department Rank',
      'classRankFull': 'Class',
      'departmentRankFull': 'Dept.',
      'topPercentage': 'Top %p%',
      'totalStudents': 'Total Students',
      'earnedCredits': 'Earned Credits',
      'failedCredits': 'Failed Credits',
      'totalCredits': 'Total Credits',
      'score': 'Score',
      'pass': 'Pass',
      'fail': 'Fail',
      'failedCoursesCount': '%d courses failed',
      'courseCredit': 'Credit',
      'courseCount': 'Courses',
      'midtermScore': 'Midterm Score',
      'finalScore': 'Final Score',
      'usualScore': 'Usual Score',
      'loadGradesFailed': 'Failed to load grades',
      'cannotGetStudentId': 'Cannot get student ID',
      'gradesFeatureName': 'Grades',
      'gradesLoginDesc': 'Cannot view grades in guest mode\nLogin to view and cache grade data',
      'semesterGradesList': 'Semester Grades',
      'semesterSummary': 'Avg: %a | Credits: %e/%t',
      
      // 學分統計相關
      'creditStats': 'Credit Statistics',
      'graduationRequirement': 'Graduation Requirements',
      'requiredCredits': 'Required Credits',
      'electiveCredits': 'Elective Credits',
      'liberalArtsCredits': 'Liberal Arts Credits',
      'professionalRequired': 'Professional Required',
      'professionalElective': 'Professional Elective',
      'commonRequired': 'Common Required',
      'commonElective': 'Common Elective',
      'freeElective': 'Free Elective',
      'creditsProgress': 'Credits Progress',
      'remaining': 'Remaining',
      'completed': 'Completed',
      'inProgress': 'In Progress',
      'creditUnit': '%d Credits',
      'minimumGraduationCredits': 'Minimum Graduation Credits',
      'currentTotalCredits': 'Current Total Credits',
      'creditsNeeded': 'Credits Needed',
      
      // 學院、系所、班級相關
      'college': 'College',
      'selectCollege': 'Select College',
      'departmentOrProgram': 'Department',
      'selectDepartment': 'Select Department',
      'classGrade': 'Class',
      'selectClass': 'Select Class',
      'selectClassOrProgram': 'Select Class or Program',
      'program': 'Program',
      'gradeLevel': 'Grade Level',
      'academicYear': 'Academic Year',
      'openingClass': 'Opening Class',
      'classInfo': 'Class Information',
      'educationSystem': 'Education System',
      'unknownCourse': 'Unknown Course',
      
      // 空教室查詢相關
      'emptyClassroomQuery': 'Empty Classroom Query',
      'building': 'Building',
      'floor': 'Floor',
      'room': 'Room',
      'available': 'Free',
      'occupied': 'Busy',
      'selectTimeSlot': 'Select Time Slot',
      'selectBuilding': 'Select Building',
      'noEmptyClassrooms': 'No Empty Classrooms',
      'searchResults': 'Search Results',
      
      // 其他通用字串
      'filter': 'Filter',
      'sort': 'Sort',
      'ascending': 'Ascending',
      'descending': 'Descending',
      'all': 'All',
      'none': 'None',
      'selectAll': 'Select All',
      'deselectAll': 'Deselect All',
      'apply': 'Apply',
      'clear': 'Clear',
      'refresh': 'Refresh',
      'more': 'More',
      'less': 'Less',
      'detail': 'Detail',
      'details': 'Details',
      'information': 'Information',
      'notice': 'Notice',
      'announcement': 'Announcement',
      'attachment': 'Attachment',
      'attachments': 'Attachments',
      'noAttachments': 'No Attachments',
      'viewDetails': 'View Details',
      'backToList': 'Back to List',
      
      // 關於頁面
      'contributors': 'Contributors',
      'seniorContributors': 'Senior Contributors',
      'specialThanks': 'Special Thanks',
      'legalInformation': 'Legal Information',
      'privacyPolicyTitle': 'Privacy Policy',
      'privacyPolicyDesc': 'Learn how we protect your privacy',
      'termsOfServiceTitle': 'Terms of Service',
      'termsOfServiceDesc': 'Please read this terms before using the service',
      'openSourceProject': 'Open Source Project',
      'tatSourceCode': 'TAT 2 Source Code',
      'forEducationalUseOnly': 'For educational use only',
      'coreFeatureReference': 'NTUT Course App Core Technology Reference',
      'webCrawlerReference': 'NTUT Course Crawler & Web Version Reference',
      
      // 登入相關
      'guestMode': 'Guest Mode',
      'featureRequiresLogin': '%s requires login to use',
      'loginToUpdate': 'Login to Update',
      'cachedData': 'Cached Data',
      'pleaseLoginFirst': 'Please login first',
      'loginTimeout': 'Login timeout',
      'pleaseRelogin': 'Please login again',
      'connectionInterrupted': 'Connection interrupted',
      'loginSuccess': 'Login successful',
      'unknownError': 'Unknown error',
      
      // 課程查詢頁面專用
      'categoryFilter': 'Category',
      'timeFilter': 'Time Filter',
      'collegeFilter': 'College Filter',
      'classQuery': 'Class Query',
      'clearFilters': 'Clear Filters',
      'excludeConflicts': 'Exclude Conflicts',
      'selectCategories': 'Select one or more categories',
      'userCourseTableNotFound': 'User course table not found',
      'loadedCourses': 'Loaded %d courses',
      'removedConflicts': 'Removed %d conflict time slots',
      'loadFailedWithMsg': 'Load failed: %s',
      'selectClassOrProgramTitle': 'Select Class or Program',
      'searchProgramName': 'Search program name',
      'coursesCount': '%d Courses',
      'noCourseData2': 'No course data for %s',
      
      // Notification settings
      'badgeNotification': 'Badge Notification',
      'autoCheckEnabled': 'Auto-check enabled',
      'autoCheckDisabled': 'Auto-check disabled',
      'showAllBadges': 'Show all badges',
      'hiddenAllBadges': 'Hidden all badges',
      
      // i-Learn files
      'loadFilesError': 'Error loading file list: %s',
      
      // Empty classroom query page
      'allBuildings': 'All Buildings',
      'selectFloor': 'Select Floor',
      'allFloors': 'All Floors',
      'floorNumber': 'Floor %d',
      'queryFailed': 'Query failed, please try again later',
      'errorOccurred': 'Error occurred: %s',
      'foundClassrooms': 'Found %d classrooms',
      'periodSchedule': 'Period Schedule',
      'freeTime': 'Free',
      'busyTime': 'Occupied',
      'noClassroomData': 'No classroom data available',
      'switchOtherDay': 'Try switching to another day',
      'noMatchingClassrooms': 'No matching classrooms',
      'adjustFilters': 'Try adjusting the filters',
      
      // Course search page specific - new
      'selectOneOrMoreCategories': 'Select one or more categories',
      'selectOneCollege': 'Select a college',
      'searching': 'Searching...',
      'startSearching': 'Start Searching Courses',
      'searchHint': 'Enter keywords or tap the button\nto set filters or select a class',
      'noMatchingCourses': 'No matching courses found',
      'tryAdjustingFilters': 'Try adjusting search criteria or filters',
      'coursesFound': 'Found %d courses',
      'deselectConflicts': 'Exclude Conflicts',
      'noUserCourseTable': 'User course table not found',
      'deselectedConflicts': 'Deselected %d conflict time slots',
      'firstPage': 'First Page',
      'previousPage': 'Previous Page',
      'nextPage': 'Next Page',
      'lastPage': 'Last Page',
      'creditValue': '%s Credits',
      'hourValue': '%s Hours',
      'loadedClassCourses': 'Loaded courses for %t (%d courses)',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
