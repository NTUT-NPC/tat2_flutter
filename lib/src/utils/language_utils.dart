import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_settings_service.dart';

/// 語言工具類 - 參考 TAT 的實現
/// 提供獲取當前語言的方法
class LanguageUtils {
  /// 獲取當前語言代碼
  /// 返回 'zh' 或 'en'
  static String getLanguageCode(BuildContext context) {
    try {
      // 嘗試從 Provider 獲取 ThemeSettingsService
      final themeSettings = Provider.of<ThemeSettingsService>(context, listen: false);
      final locale = themeSettings.locale;
      if (locale != null) {
        return locale.languageCode;
      }
    } catch (e) {
      // Provider 可能不存在，忽略錯誤
    }
    
    try {
      // 回退到 Localizations
      final locale = Localizations.localeOf(context);
      return locale.languageCode;
    } catch (e) {
      // 如果出錯，默認返回中文
      return 'zh';
    }
  }
  
  /// 從 ThemeSettingsService 獲取語言代碼
  static String getLanguageCodeFromSettings(ThemeSettingsService settings) {
    final locale = settings.locale;
    if (locale != null) {
      return locale.languageCode;
    }
    return 'zh'; // 默認中文
  }
  
  /// 判斷當前是否為英文模式
  static bool isEnglish(BuildContext context) {
    return getLanguageCode(context) == 'en';
  }
  
  /// 判斷當前是否為中文模式
  static bool isChinese(BuildContext context) {
    return getLanguageCode(context) == 'zh';
  }
}
