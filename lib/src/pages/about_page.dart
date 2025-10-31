import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import 'privacy_policy_page.dart';
import 'terms_of_service_page.dart';

/// 關於我們頁面
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';
  String _buildNumber = '';
  List<dynamic> _contributors = [];
  bool _isLoadingContributors = true;
  List<dynamic> _specialThanksContributors = [];
  bool _isLoadingSpecialThanks = true;
  
  // 緩存相關常量
  static const String _cacheKeyMainContributors = 'main_contributors_cache';
  static const String _cacheKeyMainTimestamp = 'main_contributors_timestamp';
  static const String _cacheKeySpecialThanks = 'special_thanks_cache';
  static const String _cacheKeySpecialTimestamp = 'special_thanks_timestamp';
  static const Duration _cacheDuration = Duration(hours: 24); // 緩存 24 小時

  // Repositories to feature in the "Special Thanks" section
  Map<String, String> _getSpecialThanksRepos(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return {
      'NEO-TAT/tat_flutter': l10n.coreFeatureReference,
      'gnehs/ntut-course-web': l10n.webCrawlerReference,
    };
  }

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
    _loadAllContributors();
  }

  Future<void> _loadAllContributors() async {
    // Set loading states
    setState(() {
      _isLoadingContributors = true;
      _isLoadingSpecialThanks = true;
    });

    final prefs = await SharedPreferences.getInstance();

    // 嘗試從緩存加載主項目貢獻者
    final cachedMainContributors = await _loadFromCache(
      prefs,
      _cacheKeyMainContributors,
      _cacheKeyMainTimestamp,
    );

    if (cachedMainContributors != null) {
      // 使用緩存數據
      if (mounted) {
        setState(() {
          _contributors = cachedMainContributors;
          _isLoadingContributors = false;
        });
      }
    } else {
      // 從 API 獲取主項目貢獻者
      final mainContributors = await _fetchContributors(
          'https://api.github.com/repos/NTUT-NPC/tat2_flutter/contributors');
      
      if (mainContributors.isNotEmpty) {
        await _saveToCache(
          prefs,
          _cacheKeyMainContributors,
          _cacheKeyMainTimestamp,
          mainContributors,
        );
      }
      
      if (mounted) {
        setState(() {
          _contributors = mainContributors;
          _isLoadingContributors = false;
        });
      }
    }

    // 嘗試從緩存加載特別感謝貢獻者
    final cachedSpecialThanks = await _loadFromCache(
      prefs,
      _cacheKeySpecialThanks,
      _cacheKeySpecialTimestamp,
    );

    if (cachedSpecialThanks != null) {
      // 使用緩存數據
      if (mounted) {
        setState(() {
          _specialThanksContributors = cachedSpecialThanks;
          _isLoadingSpecialThanks = false;
        });
      }
    } else {
      // 從 API 獲取特別感謝貢獻者
      final specialThanksRepos = _getSpecialThanksRepos(context);
      final specialThanksFutures = specialThanksRepos.keys
          .map((slug) => _fetchContributors(
              'https://api.github.com/repos/$slug/contributors',
              repoSlug: slug))
          .toList();

      final specialThanksResults = await Future.wait(specialThanksFutures);
      final allSpecialThanks =
          specialThanksResults.expand((result) => result).toList();

      if (allSpecialThanks.isNotEmpty) {
        await _saveToCache(
          prefs,
          _cacheKeySpecialThanks,
          _cacheKeySpecialTimestamp,
          allSpecialThanks,
        );
      }

      if (mounted) {
        setState(() {
          _specialThanksContributors = allSpecialThanks;
          _isLoadingSpecialThanks = false;
        });
      }
    }
  }

  /// 從緩存加載數據
  Future<List<dynamic>?> _loadFromCache(
    SharedPreferences prefs,
    String cacheKey,
    String timestampKey,
  ) async {
    try {
      final timestampStr = prefs.getString(timestampKey);
      if (timestampStr == null) return null;

      final timestamp = DateTime.parse(timestampStr);
      final now = DateTime.now();

      // 檢查緩存是否過期
      if (now.difference(timestamp) > _cacheDuration) {
        debugPrint('Cache expired for $cacheKey');
        return null;
      }

      final cachedData = prefs.getString(cacheKey);
      if (cachedData == null) return null;

      final decoded = json.decode(cachedData) as List<dynamic>;
      debugPrint('Loaded ${decoded.length} items from cache: $cacheKey');
      return decoded;
    } catch (e) {
      debugPrint('Error loading cache for $cacheKey: $e');
      return null;
    }
  }

  /// 保存數據到緩存
  Future<void> _saveToCache(
    SharedPreferences prefs,
    String cacheKey,
    String timestampKey,
    List<dynamic> data,
  ) async {
    try {
      final encoded = json.encode(data);
      await prefs.setString(cacheKey, encoded);
      await prefs.setString(timestampKey, DateTime.now().toIso8601String());
      debugPrint('Saved ${data.length} items to cache: $cacheKey');
    } catch (e) {
      debugPrint('Error saving cache for $cacheKey: $e');
    }
  }

  Future<List<dynamic>> _fetchContributors(String url, {String? repoSlug}) async {
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final contributors = json.decode(response.body) as List<dynamic>;
        if (repoSlug != null) {
          // Attach repository info for context
          return contributors
              .map((c) => {...c, 'repo_slug': repoSlug})
              .toList();
        }
        return contributors;
      } else {
        debugPrint(
            'Failed to load contributors from $url: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching contributors from $url: $e');
    }
    return [];
  }

  Future<void> _loadVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App 圖示和名稱
            const SizedBox(height: 40),
            // 暫時移除圖片顯示
            // Container(
            //   width: 120,
            //   height: 120,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(20),
            //     child: Image.asset(
            //       isDarkMode
            //         ? 'assets/images/splash-dark.png'
            //         : 'assets/images/splash.png',
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            Text(
              'TAT 北科生活',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _version.isEmpty ? 'Loading...' : 'Version $_version+$_buildNumber',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),



            const SizedBox(height: 24),

            // 作者資訊
            _buildSectionTitle(l10n.contributors, theme),
            if (_isLoadingContributors)
              const Center(child: CircularProgressIndicator())
            else
              ..._contributors.map((contributor) {
                return _buildClickableCard(
                  title: contributor['login'],
                  subtitle: 'GitHub',
                  imageUrl: contributor['avatar_url'],
                  onTap: () => _launchUrl(contributor['html_url']),
                );
              }).toList(),

            const SizedBox(height: 24),

            // Special Thanks Section
            _buildSectionTitle(l10n.seniorContributors, theme),
            if (_isLoadingSpecialThanks)
              const Center(child: CircularProgressIndicator())
            else
              ..._specialThanksContributors.map((contributor) {
                return _buildClickableCard(
                  title: contributor['login'],
                  subtitle: 'GitHub (${contributor['repo_slug']})',
                  imageUrl: contributor['avatar_url'],
                  onTap: () => _launchUrl(contributor['html_url']),
                );
              }).toList(),

            const SizedBox(height: 24),

            // 特別感謝
            _buildSectionTitle(l10n.specialThanks, theme),
            ..._getSpecialThanksRepos(context).entries.map((entry) {
              return _buildClickableCard(
                icon: Icons.favorite,
                title: entry.key,
                subtitle: entry.value,
                onTap: () => _launchUrl('https://github.com/${entry.key}'),
              );
            }),

            const SizedBox(height: 24),

            // 法律資訊
            _buildSectionTitle(l10n.legalInformation, theme),
            _buildClickableCard(
              icon: Icons.privacy_tip,
              title: l10n.privacyPolicyTitle,
              subtitle: l10n.privacyPolicyDesc,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage(),
                  ),
                );
              },
            ),
            _buildClickableCard(
              icon: Icons.description,
              title: l10n.termsOfServiceTitle,
              subtitle: l10n.termsOfServiceDesc,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServicePage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // 開源資訊
            _buildSectionTitle(l10n.openSourceProject, theme),
            _buildClickableCard(
              icon: Icons.code,
              title: 'NTUT-NPC/tat2_flutter',
              subtitle: l10n.tatSourceCode,
              onTap: () =>
                  _launchUrl('https://github.com/NTUT-NPC/tat2_flutter'),
            ),

            const SizedBox(height: 40),

            // 版權資訊
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '© ${DateTime.now().year} TAT\n'
                '${l10n.forEducationalUseOnly}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildClickableCard({
    IconData? icon,
    String? imageUrl,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    Widget leadingWidget;
    if (imageUrl != null) {
      leadingWidget = ClipOval(
        child: Image.network(
          imageUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.person, color: Colors.grey),
        ),
      );
    } else if (icon != null) {
      leadingWidget = Icon(icon, color: Colors.grey[700]);
    } else {
      leadingWidget = const SizedBox(width: 40, height: 40); // Placeholder
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: leadingWidget,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.open_in_new, size: 20),
        onTap: onTap,
      ),
    );
  }
}
