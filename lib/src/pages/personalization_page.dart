import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_settings_service.dart';
import '../services/course_color_service.dart';
import '../services/badge_service.dart';
import '../l10n/app_localizations.dart';
import '../../ui/theme/app_theme.dart';

/// 個人化設定頁面
class PersonalizationPage extends StatefulWidget {
  const PersonalizationPage({super.key});

  @override
  State<PersonalizationPage> createState() => _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage> {
  @override
  void initState() {
    super.initState();
    _checkAndShowIntroDialog();
  }

  /// 檢查是否首次訪問，如果是則顯示介紹彈窗
  Future<void> _checkAndShowIntroDialog() async {
    final shouldShow = await BadgeService().shouldShowPersonalizationBadge();
    
    if (shouldShow && mounted) {
      // 標記為已訪問
      await BadgeService().markPersonalizationAsVisited();
      
      // 延遲一下讓頁面完全加載後再顯示彈窗
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        _showIntroDialog();
      }
    }
  }

  /// 顯示個人化功能介紹彈窗
  void _showIntroDialog() {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.palette,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(l10n.welcomeToPersonalization),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.personalizationIntro,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 16),
              _buildIntroPoint(
                Icons.color_lens,
                l10n.themeColorOption,
                l10n.themeColorDesc,
              ),
              const SizedBox(height: 12),
              _buildIntroPoint(
                Icons.brightness_6,
                l10n.themeModeOption,
                l10n.themeModeDesc,
              ),
              const SizedBox(height: 12),
              _buildIntroPoint(
                Icons.language,
                l10n.languageOption,
                l10n.languageDesc,
              ),
              const SizedBox(height: 12),
              _buildIntroPoint(
                Icons.grid_view,
                l10n.courseTableStyleOption,
                l10n.courseTableStyleDesc,
              ),
              const SizedBox(height: 12),
              _buildIntroPoint(
                Icons.palette_outlined,
                l10n.courseColorStyleOption,
                l10n.courseColorStyleDesc,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.longPressCourseTip,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.startExploring),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPoint(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.personalization),
      ),
      body: ListView(
        children: [
          // 配色設定
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.themeSettings,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Consumer<ThemeSettingsService>(
            builder: (context, themeService, child) {
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: Text(l10n.courseColor),
                    subtitle: Text(_getColorName(themeService.themeColorId, context)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showThemeColorDialog(context, themeService),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(themeService.themeModeIcon),
                    title: Text(l10n.themeMode),
                    subtitle: Text(_getThemeModeString(themeService.themeMode, context)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showThemeModeDialog(context, themeService),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(themeService.localeIcon),
                    title: Text(l10n.language),
                    subtitle: Text(_getLocaleString(themeService.locale, context)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showLanguageDialog(context, themeService),
                  ),
                ],
              );
            },
          ),
          const Divider(),
          
          // 課程設定
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.courseSettings,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Consumer<ThemeSettingsService>(
            builder: (context, themeService, child) {
              return ListTile(
                leading: Icon(themeService.courseTableStyleIcon),
                title: Text(l10n.courseTableStyle),
                subtitle: Text(_getCourseTableStyleName(themeService.courseTableStyle, context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCourseTableStyleDialog(context, themeService),
              );
            },
          ),
          const Divider(),
          Consumer<ThemeSettingsService>(
            builder: (context, themeService, child) {
              return ListTile(
                leading: Icon(themeService.courseColorStyleIcon),
                title: Text(l10n.courseColorStyle),
                subtitle: Text(_getCourseColorStyleName(themeService.courseColorStyle, context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCourseColorStyleDialog(context, themeService),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.courseColorInfo),
            subtitle: Text(l10n.customYourCourseTable),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCourseColorInfoDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shuffle),
            title: Text(l10n.reassignColors),
            subtitle: Text(l10n.reassignColorsDesc),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showReassignColorsDialog(context),
          ),
        ],
      ),
    );
  }

  String _getColorName(String colorId, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (colorId) {
      case 'blue':
        return l10n.colorBlue;
      case 'purple':
        return l10n.colorPurple;
      case 'green':
        return l10n.colorGreen;
      case 'orange':
        return l10n.colorOrange;
      case 'red':
        return l10n.colorRed;
      case 'pink':
        return l10n.colorPink;
      case 'teal':
        return l10n.colorTeal;
      case 'indigo':
        return l10n.colorIndigo;
      case 'yellow':
        return l10n.colorYellow;
      default:
        return l10n.colorBlue;
    }
  }

  void _showThemeColorDialog(BuildContext context, ThemeSettingsService themeService) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.courseColor),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: AppTheme.themeColors.entries.map((entry) {
              final colorId = entry.key;
              final themeColor = entry.value;
              final isSelected = themeService.themeColorId == colorId;
              
              return InkWell(
                onTap: () {
                  themeService.setThemeColor(colorId);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 64,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: themeColor.seedColor,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.seedColor.withOpacity(0.3),
                              blurRadius: isSelected ? 12 : 6,
                              spreadRadius: isSelected ? 2 : 0,
                            ),
                          ],
                        ),
                        child: isSelected
                            ? const Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ],
                              )
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getColorName(colorId, context),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showThemeModeDialog(BuildContext context, ThemeSettingsService themeService) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectThemeMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.followSystem),
              subtitle: Text(l10n.followSystemDesc),
              value: ThemeMode.system,
              groupValue: themeService.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeService.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.lightMode),
              subtitle: Text(l10n.lightModeDesc),
              value: ThemeMode.light,
              groupValue: themeService.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeService.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.darkMode),
              subtitle: Text(l10n.darkModeDesc),
              value: ThemeMode.dark,
              groupValue: themeService.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeService.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCourseTableStyleDialog(BuildContext context, ThemeSettingsService themeService) {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectCourseTableStyle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<CourseTableStyle>(
              title: Text(l10n.material3Style),
              subtitle: Text(l10n.material3StyleDesc),
              secondary: const Icon(Icons.layers),
              value: CourseTableStyle.material3,
              groupValue: themeService.courseTableStyle,
              onChanged: (value) {
                if (value != null) {
                  themeService.setCourseTableStyle(value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.switchedToMaterial3),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            RadioListTile<CourseTableStyle>(
              title: Text(l10n.classicStyle),
              subtitle: Text(l10n.classicStyleDesc),
              secondary: const Icon(Icons.grid_on),
              value: CourseTableStyle.classic,
              groupValue: themeService.courseTableStyle,
              onChanged: (value) {
                if (value != null) {
                  themeService.setCourseTableStyle(value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.switchedToClassic),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            RadioListTile<CourseTableStyle>(
              title: Text(l10n.tatStyle),
              subtitle: Text(l10n.tatStyleDesc),
              secondary: const Icon(Icons.table_chart),
              value: CourseTableStyle.tat,
              groupValue: themeService.courseTableStyle,
              onChanged: (value) {
                if (value != null) {
                  themeService.setCourseTableStyle(value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.switchedToTat),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCourseColorStyleDialog(BuildContext context, ThemeSettingsService themeService) {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectCourseColorStyle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<CourseColorStyle>(
              title: Text(l10n.tatColorStyle),
              subtitle: Text(l10n.tatColorStyleDesc),
              secondary: const Icon(Icons.palette_outlined),
              value: CourseColorStyle.tat,
              groupValue: themeService.courseColorStyle,
              onChanged: (value) {
                if (value != null) {
                  themeService.setCourseColorStyle(value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.switchedToTatColor),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            RadioListTile<CourseColorStyle>(
              title: Text(l10n.themeColorStyle),
              subtitle: Text(l10n.themeColorStyleDesc),
              secondary: const Icon(Icons.color_lens),
              value: CourseColorStyle.theme,
              groupValue: themeService.courseColorStyle,
              onChanged: (value) {
                if (value != null) {
                  themeService.setCourseColorStyle(value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.switchedToThemeColor),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            RadioListTile<CourseColorStyle>(
              title: Text(l10n.rainbowColorStyle),
              subtitle: Text(l10n.rainbowColorStyleDesc),
              secondary: const Icon(Icons.gradient),
              value: CourseColorStyle.rainbow,
              groupValue: themeService.courseColorStyle,
              onChanged: (value) {
                if (value != null) {
                  themeService.setCourseColorStyle(value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.switchedToRainbowColor),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showLanguageDialog(BuildContext context, ThemeSettingsService themeService) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.followSystem),
              subtitle: Text(l10n.followSystemLang),
              value: 'system',
              groupValue: themeService.locale == null 
                  ? 'system' 
                  : themeService.locale!.languageCode,
              onChanged: (value) {
                themeService.setLocale(null);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.traditionalChinese),
              subtitle: const Text('Traditional Chinese / 繁體中文'),
              value: 'zh',
              groupValue: themeService.locale == null 
                  ? 'system' 
                  : themeService.locale!.languageCode,
              onChanged: (value) {
                themeService.setLocale(const Locale('zh', 'TW'));
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.english),
              subtitle: const Text('English'),
              value: 'en',
              groupValue: themeService.locale == null 
                  ? 'system' 
                  : themeService.locale!.languageCode,
              onChanged: (value) {
                themeService.setLocale(const Locale('en', 'US'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCourseColorInfoDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeService = Provider.of<ThemeSettingsService>(context, listen: false);
    final colorStyle = themeService.courseColorStyle;
    
    // 根據配色風格顯示不同的說明
    String title;
    String description;
    List<String> features;
    
    switch (colorStyle) {
      case CourseColorStyle.tat:
        title = l10n.tatMacaronColor;
        description = l10n.tatMacaronColorDesc;
        features = [
          l10n.softMacaronTone,
          l10n.eyeFriendlyLightColor,
          l10n.highRecognitionColor,
        ];
        break;
      case CourseColorStyle.theme:
        title = l10n.themeDynamicColor;
        description = l10n.themeDynamicColorDesc;
        features = [
          l10n.blendWithTheme,
          l10n.warmColdGradient,
          l10n.autoAdaptMode,
        ];
        break;
      case CourseColorStyle.rainbow:
        title = l10n.rainbowColor;
        description = l10n.rainbowColorDesc;
        features = [
          l10n.evenHueDistribution,
          l10n.maxRecognition,
          l10n.independentOfTheme,
        ];
        break;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          colorStyle == CourseColorStyle.tat 
              ? Icons.palette_outlined
              : colorStyle == CourseColorStyle.theme
                  ? Icons.color_lens
                  : Icons.gradient,
          size: 48,
        ),
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              ...features.map((feature) => _buildInfoPoint('•', feature)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.longPressToCustomColor,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.gotIt),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoPoint(String bullet, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bullet,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
  
  void _showReassignColorsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeService = Provider.of<ThemeSettingsService>(context, listen: false);
    final colorStyle = themeService.courseColorStyle;
    
    // 根據配色風格顯示不同的說明
    String colorSystemName;
    switch (colorStyle) {
      case CourseColorStyle.tat:
        colorSystemName = l10n.tatMacaronColorSystem;
        break;
      case CourseColorStyle.theme:
        colorSystemName = l10n.themeGradientColorSystem;
        break;
      case CourseColorStyle.rainbow:
        colorSystemName = l10n.rainbowColorSystem;
        break;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.shuffle,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(l10n.reassignColorsConfirm),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.thisWillDo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildInfoPoint('•', l10n.clearAllCustomColors),
              _buildInfoPoint('•', l10n.reassignCourseColors),
              _buildInfoPoint('•', l10n.useColorSystem(colorSystemName)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.cannotUndo,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final courseColorService = Provider.of<CourseColorService>(context, listen: false);
              await courseColorService.reassignAllColors();
              
              // 調試：顯示分配結果
              final colorIndices = courseColorService.getAllCourseColorIndices();
              print(' 課程顏色分配結果（共 ${colorIndices.length} 個）：');
              final sortedEntries = colorIndices.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key));
              for (final entry in sortedEntries) {
                print('  ${entry.key}: 索引 ${entry.value}');
              }
              
              // 檢查重複
              final indexCounts = <int, List<String>>{};
              for (final entry in colorIndices.entries) {
                indexCounts[entry.value] ??= [];
                indexCounts[entry.value]!.add(entry.key);
              }
              print(' 顏色使用統計：');
              for (final entry in indexCounts.entries) {
                if (entry.value.length > 1) {
                  print('    索引 ${entry.key} 被 ${entry.value.length} 個課程使用: ${entry.value.join(", ")}');
                } else {
                  print('   索引 ${entry.key}: ${entry.value[0]}');
                }
              }
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.reassignedWithSystem(colorSystemName)),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  /// 獲取主題模式的國際化字串
  String _getThemeModeString(ThemeMode mode, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (mode) {
      case ThemeMode.light:
        return l10n.lightMode;
      case ThemeMode.dark:
        return l10n.darkMode;
      default:
        return l10n.followSystem;
    }
  }

  /// 獲取語言設定的國際化字串
  String _getLocaleString(Locale? locale, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (locale == null) return l10n.followSystem;
    if (locale.languageCode == 'zh') return l10n.traditionalChinese;
    if (locale.languageCode == 'en') return 'English';
    return l10n.followSystem;
  }

  /// 獲取課表風格的國際化字串
  String _getCourseTableStyleName(CourseTableStyle style, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (style) {
      case CourseTableStyle.material3:
        return l10n.material3Style;
      case CourseTableStyle.classic:
        return l10n.classicStyle;
      case CourseTableStyle.tat:
        return l10n.tatStyle;
    }
  }

  /// 獲取課程配色風格的國際化字串
  String _getCourseColorStyleName(CourseColorStyle style, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (style) {
      case CourseColorStyle.tat:
        return l10n.tatColorStyle;
      case CourseColorStyle.theme:
        return l10n.themeColorStyle;
      case CourseColorStyle.rainbow:
        return l10n.rainbowColorStyle;
    }
  }
}
