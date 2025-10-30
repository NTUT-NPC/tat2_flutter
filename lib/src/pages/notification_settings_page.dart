import 'package:flutter/material.dart';
import '../services/badge_service.dart';
import '../l10n/app_localizations.dart';

/// 通知設定頁面
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _hideAllBadges = false;
  bool _autoCheckISchool = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final hideAll = await BadgeService().isHideAllBadges();
    final autoCheck = await BadgeService().isAutoCheckISchoolEnabled();
    
    setState(() {
      _hideAllBadges = hideAll;
      _autoCheckISchool = autoCheck;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationSettings),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // 紅點設定區域
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.badgeNotification,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_off),
                  title: Text(l10n.hideAllBadges),
                  subtitle: Text(l10n.hideAllBadgesDesc),
                  value: _hideAllBadges,
                  onChanged: (value) async {
                    await BadgeService().setHideAllBadges(value);
                    setState(() {
                      _hideAllBadges = value;
                    });
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value ? l10n.hiddenAllBadges : l10n.showAllBadges),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
                const Divider(),

                // i學院設定區域
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.ntutLearn,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                
                SwitchListTile(
                  secondary: const Icon(Icons.sync),
                  title: Text(l10n.autoCheckAnnouncements),
                  subtitle: Text(l10n.autoCheckAnnouncementsDesc),
                  value: _autoCheckISchool,
                  onChanged: (value) async {
                    await BadgeService().setAutoCheckISchool(value);
                    setState(() {
                      _autoCheckISchool = value;
                    });
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value ? l10n.autoCheckEnabled : l10n.autoCheckDisabled),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
                const Divider(),

              ],
            ),
    );
  }
}
