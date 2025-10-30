import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
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

  // Repositories to feature in the "Special Thanks" section
  final Map<String, String> _specialThanksRepos = {
    'NEO-TAT/tat_flutter': '北科課表 APP 核心技術參考',
    'gnehs/ntut-course-web': '北科課程爬蟲與網頁版參考',
  };

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

    // Fetch contributors for the main project
    final mainContributorsFuture = _fetchContributors(
        'https://api.github.com/repos/NTUT-NPC/tat2_flutter/contributors');

    // Fetch contributors for all "Special Thanks" repositories concurrently
    final specialThanksFutures = _specialThanksRepos.keys
        .map((slug) => _fetchContributors(
            'https://api.github.com/repos/$slug/contributors',
            repoSlug: slug))
        .toList();

    // Process main project contributors
    final mainContributors = await mainContributorsFuture;
    if (mounted) {
      setState(() {
        _contributors = mainContributors;
        _isLoadingContributors = false;
      });
    }

    // Process "Special Thanks" contributors
    final specialThanksResults = await Future.wait(specialThanksFutures);
    if (mounted) {
      setState(() {
        _specialThanksContributors =
            specialThanksResults.expand((result) => result).toList();
        _isLoadingSpecialThanks = false;
      });
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
            _buildSectionTitle('貢獻者', theme),
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
            _buildSectionTitle('元老級貢獻者', theme),
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
            _buildSectionTitle('特別感謝', theme),
            ..._specialThanksRepos.entries.map((entry) {
              return _buildClickableCard(
                icon: Icons.favorite,
                title: entry.key,
                subtitle: entry.value,
                onTap: () => _launchUrl('https://github.com/${entry.key}'),
              );
            }),

            const SizedBox(height: 24),

            // 法律資訊
            _buildSectionTitle('法律資訊', theme),
            _buildClickableCard(
              icon: Icons.privacy_tip,
              title: '隱私權條款',
              subtitle: '了解我們如何保護您的隱私',
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
              title: '使用者條款',
              subtitle: '使用服務前請詳閱本條款',
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
            _buildSectionTitle('開源專案', theme),
            _buildClickableCard(
              icon: Icons.code,
              title: 'NTUT-NPC/tat2_flutter',
              subtitle: 'TAT 2 原始碼',
              onTap: () =>
                  _launchUrl('https://github.com/NTUT-NPC/tat2_flutter'),
            ),

            const SizedBox(height: 40),

            // 版權資訊
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '© ${DateTime.now().year} TAT\n'
                '僅供學習交流使用',
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
