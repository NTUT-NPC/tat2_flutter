import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/ischool_plus/announcement.dart';
import '../../models/ischool_plus/announcement_detail.dart';
import '../../services/ischool_plus_service.dart';
import '../../services/ischool_plus_cache_service.dart';
import '../../services/badge_service.dart';
import '../../services/file_download_service.dart';
import '../../services/file_store.dart';
import '../../l10n/app_localizations.dart';

/// 課程公告列表頁面
class AnnouncementListPage extends StatefulWidget {
  final String courseId;
  final String courseName;

  const AnnouncementListPage({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<AnnouncementListPage> createState() => _AnnouncementListPageState();
}

class _AnnouncementListPageState extends State<AnnouncementListPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<ISchoolPlusAnnouncement> _announcements = [];

  @override
  void initState() {
    super.initState();
    // 監聽 BadgeService 變化
    BadgeService().addListener(_onBadgeChanged);
    _loadAnnouncements();
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

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final service = ISchoolPlusService.instance;
      
      // 確保已登入
      if (!service.isLoggedIn) {
        final loginSuccess = await service.login();
        if (!loginSuccess) {
          if (mounted) {
            setState(() {
              _errorMessage = AppLocalizations.of(context).loginISchoolFailed;
              _isLoading = false;
            });
          }
          return;
        }
      }

      // 取得公告列表（手動操作，使用高優先級）
      final announcements = await service.connector
          .getCourseAnnouncements(widget.courseId, highPriority: true);

      // 同步公告列表（不自動清除紅點，只有用戶點擊查看時才標記為已讀）
      final announcementIds = announcements
          .where((a) => a.nid != null && a.nid!.isNotEmpty)
          .map((a) => a.nid!)
          .toList();
      
      await BadgeService().syncCourseAnnouncements(
        widget.courseId,
        announcementIds,
      );

      setState(() {
        _announcements = announcements;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          // 更友好的錯誤提示
          if (e.toString().contains('API error')) {
            _errorMessage = AppLocalizations.of(context).noCourseAnnouncements;
          } else {
            _errorMessage = AppLocalizations.of(context).loadAnnouncementsFailed;
          }
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnnouncements,
            tooltip: AppLocalizations.of(context).reload,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAnnouncements,
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      );
    }

    if (_announcements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).noCoursesFound,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAnnouncements,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _announcements.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          return _buildAnnouncementItem(announcement);
        },
      ),
    );
  }

  Widget _buildAnnouncementItem(ISchoolPlusAnnouncement announcement) {
    return FutureBuilder<bool>(
      future: BadgeService().hasISchoolAnnouncementBadge(
        widget.courseId,
        announcement.nid ?? '',
      ),
      builder: (context, snapshot) {
        final hasUnread = snapshot.data ?? false;
        
        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundColor: hasUnread ? Colors.red : Colors.grey,
                child: Icon(
                  hasUnread ? Icons.mail : Icons.mail_outline,
                  color: Colors.white,
                ),
              ),
              if (hasUnread)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            announcement.subject,
            style: TextStyle(
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Icon(Icons.person, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              announcement.sender,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              announcement.postTime,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
          onTap: () {
            _showAnnouncementDialog(announcement);
          },
        );
      },
    );
  }

  /// 顯示公告詳情彈窗
  void _showAnnouncementDialog(ISchoolPlusAnnouncement announcement) async {
    // 標記為已讀
    await BadgeService().markISchoolAnnouncementAsRead(
      widget.courseId,
      announcement.nid ?? '',
    );
    
    // 立即重新整理以更新紅點狀態
    if (mounted) {
      setState(() {});
    }
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AnnouncementBottomSheet(
        announcement: announcement,
        courseId: widget.courseId,
      ),
    );
  }
}

/// 公告詳情底部彈窗
class _AnnouncementBottomSheet extends StatefulWidget {
  final ISchoolPlusAnnouncement announcement;
  final String courseId;

  const _AnnouncementBottomSheet({
    required this.announcement,
    required this.courseId,
  });

  @override
  State<_AnnouncementBottomSheet> createState() => _AnnouncementBottomSheetState();
}

class _AnnouncementBottomSheetState extends State<_AnnouncementBottomSheet> {
  bool _isLoading = true;
  String? _errorMessage;
  ISchoolPlusAnnouncementDetail? _detail;
  
  // 下載狀態管理
  final Map<String, bool> _downloadingFiles = {}; // fileName -> isDownloading
  final Map<String, double> _downloadProgress = {}; // fileName -> progress
  final Map<String, String> _downloadedFiles = {}; // fileName -> localPath

  @override
  void initState() {
    super.initState();
    _loadDetail();
    _loadDownloadedFiles();
  }

  /// 載入已下載的附件列表
  Future<void> _loadDownloadedFiles() async {
    try {
      final courseName = widget.announcement.subject; // 使用公告標題作為目錄名
      final files = await FileStore.getDownloadedFiles(courseName);
      if (mounted) {
        setState(() {
          _downloadedFiles.clear();
          _downloadedFiles.addAll(files);
        });
      }
      debugPrint('[AnnouncementAttachment] Loaded ${files.length} downloaded files');
    } catch (e) {
      debugPrint('[AnnouncementAttachment] Load downloaded files error: $e');
      if (mounted) {
        setState(() {
          _downloadedFiles.clear();
        });
      }
    }
  }

  Future<void> _loadDetail() async {
    try {
      final cacheService = ISchoolPlusCacheService();
      final courseId = widget.announcement.cid ?? '';
      final announcementId = widget.announcement.nid ?? '';
      
      // 先從緩存讀取
      final cachedDetail = await cacheService.getCachedAnnouncementDetail(courseId, announcementId);
      if (cachedDetail != null) {
        setState(() {
          _detail = cachedDetail;
          _isLoading = false;
        });
        // 背景更新緩存
        _updateCache();
        return;
      }
      
      // 緩存不存在，從網路載入
      await _fetchFromNetwork();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AppLocalizations.of(context).loadAnnouncementDetailFailedWithError(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchFromNetwork() async {
    try {
      final service = ISchoolPlusService.instance;
      final detail = await service.connector
          .getAnnouncementDetail(widget.announcement, courseId: widget.courseId);

      if (detail == null) {
        if (mounted) {
          setState(() {
            _errorMessage = AppLocalizations.of(context).cannotLoadAnnouncementDetail;
            _isLoading = false;
          });
        }
        return;
      }

      // 儲存到緩存
      final cacheService = ISchoolPlusCacheService();
      final courseId = widget.announcement.cid ?? '';
      final announcementId = widget.announcement.nid ?? '';
      await cacheService.cacheAnnouncementDetail(courseId, announcementId, detail);

      setState(() {
        _detail = detail;
        _isLoading = false;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _updateCache() async {
    try {
      final service = ISchoolPlusService.instance;
      final detail = await service.connector
          .getAnnouncementDetail(widget.announcement, courseId: widget.courseId);

      if (detail != null) {
        final cacheService = ISchoolPlusCacheService();
        final announcementId = widget.announcement.nid ?? '';
        await cacheService.cacheAnnouncementDetail(widget.courseId, announcementId, detail);
      }
    } catch (e) {
      print('[AnnouncementDialog] Failed to update cache: $e');
    }
  }

  /// 下載附件（參考教材下載邏輯）
  Future<void> _downloadAttachment(String fileName, String fileUrl) async {
    if (_downloadingFiles[fileName] == true) {
      return; // 已經在下載中
    }

    setState(() {
      _downloadingFiles[fileName] = true;
      _downloadProgress[fileName] = 0.0;
    });

    try {
      final service = ISchoolPlusService.instance;
      
      debugPrint('[AnnouncementAttachment] Starting download: $fileName');
      debugPrint('[AnnouncementAttachment] Original URL: $fileUrl');

      // 先更新公告內容以獲取最新的附件 URL（使用高優先級插隊）
      debugPrint('[AnnouncementAttachment] Updating announcement detail with high priority...');
      final updatedDetail = await service.connector
          .getAnnouncementDetail(widget.announcement, courseId: widget.courseId, highPriority: true);
      
      if (updatedDetail == null) {
        throw Exception(mounted ? AppLocalizations.of(context).cannotGetLatestAnnouncementContent : 'Cannot get latest announcement content');
      }
      
      // 從更新後的詳情中找到對應的附件 URL
      String? updatedFileUrl;
      for (final entry in updatedDetail.files.entries) {
        if (entry.key == fileName) {
          updatedFileUrl = entry.value;
          break;
        }
      }
      
      if (updatedFileUrl == null) {
        throw Exception(mounted ? AppLocalizations.of(context).cannotFindAttachment(fileName) : 'Cannot find attachment: $fileName');
      }
      
      debugPrint('[AnnouncementAttachment] Updated URL: $updatedFileUrl');
      
      // 更新緩存中的公告詳情
      final cacheService = ISchoolPlusCacheService();
      final announcementId = widget.announcement.nid ?? '';
      await cacheService.cacheAnnouncementDetail(widget.courseId, announcementId, updatedDetail);
      
      // 更新當前顯示的詳情
      if (mounted) {
        setState(() {
          _detail = updatedDetail;
        });
      }

      // 使用與教材相同的下載服務，使用更新後的 URL
      final courseName = widget.announcement.subject; // 使用公告標題作為目錄名
      final filePath = await FileDownloadService.download(
        connector: service.connector,
        url: updatedFileUrl,
        dirName: courseName,
        name: fileName,
        referer: updatedFileUrl,
        onProgress: (current, total) {
          if (total > 0) {
            setState(() {
              _downloadProgress[fileName] = current / total;
            });
          }
        },
      );

      // 重新載入已下載檔案列表
      await _loadDownloadedFiles();

      // 更新已下載檔案列表
      final downloadedFileName = filePath.split(Platform.pathSeparator).last;

      debugPrint('[AnnouncementAttachment] Download completed: $downloadedFileName');

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.downloadCompletedWithFileName(downloadedFileName)),
            action: SnackBarAction(
              label: l10n.open,
              onPressed: () => _openFile(filePath),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint('[AnnouncementAttachment] Download error: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).downloadFailedWithError(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _downloadingFiles[fileName] = false;
          _downloadProgress.remove(fileName);
        });
      }
    }
  }

  /// 開啟檔案
  Future<void> _openFile(String path) async {
    try {
      debugPrint('[AnnouncementAttachment] Opening file: $path');

      final file = File(path);
      if (!await file.exists()) {
        throw Exception(mounted ? AppLocalizations.of(context).fileNotFound : 'File not found');
      }

      final result = await OpenFilex.open(path);
      debugPrint('[AnnouncementAttachment] Open result: ${result.type} - ${result.message}');

      if (result.type != ResultType.done && mounted) {
        final l10n = AppLocalizations.of(context);
        String errorMsg = l10n.openFileFailed;

        switch (result.type) {
          case ResultType.noAppToOpen:
            errorMsg = l10n.noAppToOpenFile;
            break;
          case ResultType.fileNotFound:
            errorMsg = l10n.fileNotFoundError;
            break;
          case ResultType.permissionDenied:
            errorMsg = l10n.permissionDenied;
            break;
          case ResultType.error:
            errorMsg = l10n.openFileErrorWithMessage(result.message);
            break;
          default:
            errorMsg = result.message;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              action: SnackBarAction(
                label: l10n.share,
                onPressed: () => _shareFile(path),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[AnnouncementAttachment] Open file error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).openFileFailedWithError(e.toString()))),
        );
      }
    }
  }

  /// 分享檔案
  Future<void> _shareFile(String path) async {
    try {
      final fileName = path.split(Platform.pathSeparator).last;
      await Share.shareXFiles(
        [XFile(path)],
        subject: fileName,
      );
    } catch (e) {
      debugPrint('[AnnouncementAttachment] Share file error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).shareFailedWithError(e.toString()))),
        );
      }
    }
  }

  /// 刪除附件
  Future<void> _deleteFile(String path, String fileName) async {
    try {
      final success = await FileStore.deleteFile(path);
      
      if (success) {
        // 重新載入已下載檔案列表以確保 UI 同步
        await _loadDownloadedFiles();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).fileDeleted(fileName))),
          );
        }
      } else {
        throw Exception(mounted ? AppLocalizations.of(context).deleteFailed('') : 'Delete failed');
      }
    } catch (e) {
      debugPrint('[AnnouncementAttachment] Delete file error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).deleteFailedWithError(e.toString()))),
        );
      }
    }
  }

  /// 顯示檔案操作選單（已下載的附件）
  void _showFileActions(String fileName, String filePath) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(AppLocalizations.of(context).open),
              onTap: () {
                Navigator.pop(context);
                _openFile(filePath);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(AppLocalizations.of(context).share),
              onTap: () {
                Navigator.pop(context);
                _shareFile(filePath);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(AppLocalizations.of(context).delete, style: const TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(fileName, filePath);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 確認刪除對話框
  void _confirmDelete(String fileName, String filePath) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteFile(fileName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFile(filePath, fileName);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // 拖動指示器與標題列
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // 拖動指示器
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // 標題列
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.announcement.subject,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: onSurface),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 內容
              SliverFillRemaining(
                hasScrollBody: true,
                child: _buildContent(null),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(ScrollController? scrollController) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadDetail();
                },
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_detail == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(AppLocalizations.of(context).noAnnouncementContent),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 發送者和時間
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                _detail!.sender,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _detail!.postTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          // HTML 內容
          Html(
            data: _detail!.body,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(14),
                lineHeight: const LineHeight(1.5),
              ),
              "p": Style(
                margin: Margins.only(bottom: 8),
              ),
              "div": Style(
                margin: Margins.only(bottom: 8),
              ),
              "br": Style(
                margin: Margins.only(bottom: 4),
              ),
              "a": Style(
                color: Colors.blue,
                textDecoration: TextDecoration.underline,
              ),
            },
            onLinkTap: (url, attributes, element) async {
              if (url != null) {
                try {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context).cannotOpenLink(url))),
                      );
                    }
                  }
                } catch (e) {
                  debugPrint('[AnnouncementDialog] Error launching URL: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context).openLinkFailedWithError(e.toString()))),
                    );
                  }
                }
              }
            },
          ),
          // 附件
          if (_detail!.hasAttachments) ...[
            const SizedBox(height: 16),
            const Divider(),
            Text(
              AppLocalizations.of(context).attachments,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ..._detail!.files.entries.map((entry) {
              final fileName = entry.key;
              final fileUrl = entry.value;
              final isDownloading = _downloadingFiles[fileName] ?? false;
              final progress = _downloadProgress[fileName] ?? 0.0;
              
              // 檢查檔案是否已下載（需要檢查可能的不同檔名）
              String? downloadedPath;
              String? savedFileName;
              bool isDownloaded = false;
              
              // 嘗試找到匹配的已下載檔案
              for (final entry in _downloadedFiles.entries) {
                final currentSavedFileName = entry.key;
                // 移除擴展名後比對（因為下載後可能會自動加上擴展名）
                final baseFileName = fileName.split('.').first;
                final baseSavedFileName = currentSavedFileName.split('.').first;
                if (baseSavedFileName.contains(baseFileName) || baseFileName.contains(baseSavedFileName)) {
                  downloadedPath = entry.value;
                  savedFileName = currentSavedFileName;
                  isDownloaded = true;
                  break;
                }
              }
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    dense: true,
                    leading: Icon(
                      isDownloaded ? Icons.check_circle : Icons.attach_file,
                      size: 20,
                      color: isDownloaded ? Colors.green : Colors.blue,
                    ),
                    title: Text(
                      fileName,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      isDownloaded ? AppLocalizations.of(context).downloaded_clickToOpen : AppLocalizations.of(context).clickToDownload,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDownloaded ? Colors.green : Colors.grey,
                      ),
                    ),
                    trailing: isDownloading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              value: progress > 0 ? progress : null,
                              strokeWidth: 2,
                            ),
                          )
                        : isDownloaded
                            ? GestureDetector(
                                onTap: () => _showFileActions(savedFileName!, downloadedPath!),
                                child: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                              )
                            : const Icon(Icons.download, size: 20),
                    onTap: isDownloading
                        ? null
                        : isDownloaded
                            ? () => _openFile(downloadedPath!)
                            : () => _downloadAttachment(fileName, fileUrl),
                  ),
                  if (isDownloading && progress > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LinearProgressIndicator(value: progress),
                    ),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }
}

