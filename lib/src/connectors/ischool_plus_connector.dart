import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html;
import '../models/ischool_plus/announcement.dart';
import '../models/ischool_plus/announcement_detail.dart';
import '../models/ischool_plus/course_file.dart';

/// i學院連接器 - 參考 TAT 實作
class ISchoolPlusConnector {
  static const String _baseUrl = 'https://istudy.ntut.edu.tw/';
  static const String _ssoLoginUrl = 'https://app.ntut.edu.tw/ssoIndex.do';
  
  final Dio _dio;
  
  // 使用單一 Completer 作為互斥鎖
  Completer<void>? _lock;

  ISchoolPlusConnector({required Dio dio}) : _dio = dio {
    // 不覆蓋傳入的 Dio 配置，保持共享的設置
    // 在每個請求中單獨設置 followRedirects
  }
  
  /// 取得 Dio 實例（用於檔案下載時複製攔截器）
  Dio get dio => _dio;

  /// 登入 i學院
  /// 
  /// 登入步驟：
  /// 1. GET https://app.ntut.edu.tw/ssoIndex.do
  /// 2. POST https://app.ntut.edu.tw/oauth2Server.do
  /// 3. 跟隨重定向到 https://istudy.ntut.edu.tw/login2.php
  Future<bool> login() async {
    try {
      // Step 1: 取得 SSO Index 頁面
      final ssoIndexResponse = await _getSSOIndexResponse();
      if (ssoIndexResponse.isEmpty) {
        print('[ISchoolPlus] 登入失敗：無法取得 SSO index');
        return false;
      }

      // 解析 SSO 表單資料
      final tagNode = html_parser.parse(ssoIndexResponse);
      final nodes = tagNode.getElementsByTagName('input');
      final form = tagNode.getElementsByTagName('form').first;
      final jumpUrl = form.attributes['action'];

      final Map<String, String> oauthData = {};
      for (final node in nodes) {
        final name = node.attributes['name'];
        final value = node.attributes['value'];
        if (name != null && value != null) {
          oauthData[name] = value;
        }
      }

      // Step 2 & 3: POST 到 oauth2Server 並跟隨重定向
      for (int retry = 0; retry < 3; retry++) {
        try {
          final response = await _dio.post(
            'https://app.ntut.edu.tw/$jumpUrl',
            data: oauthData,
            options: Options(
              validateStatus: (status) => status! < 500,
              followRedirects: false,
              contentType: 'application/x-www-form-urlencoded',
            ),
          );

          // 檢查是否有重定向
          if (response.statusCode == 302 || response.statusCode == 301) {
            final location = response.headers['location']?.first;
            
            if (location != null) {
              // 跟隨重定向到 login2.php
              final login2Response = await _dio.get(
                location,
                options: Options(
                  validateStatus: (status) => status! < 500,
                ),
              );
              
              final responseData = login2Response.data.toString();
              // 檢查是否成功 (不應該包含 "lost" 字樣)
              if (!responseData.contains('lost')) {
                print('[ISchoolPlus] 登入成功');
                return true;
              }
            }
          }

          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          // 靜默重試
        }
      }

      print('[ISchoolPlus] 登入失敗：重試3次後仍失敗');
      return false;
    } catch (e, stackTrace) {
      print('[ISchoolPlus] 登入錯誤: $e');
      print(stackTrace);
      return false;
    }
  }

  /// 取得 SSO Index Response
  Future<String> _getSSOIndexResponse() async {
    final data = {
      'apOu': 'ischool_plus_oauth',
      'datetime1': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    for (int retry = 0; retry < 5; retry++) {
      try {
        final response = await _dio.get(
          _ssoLoginUrl,
          queryParameters: data,
        );

        final responseText = response.data.toString().trim();
        if (responseText.contains('ssoForm')) {
          return responseText;
        }

        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        // 靜默重試
      }
    }

    return '';
  }

  /// 選擇課程 (內部方法)
  /// 
  /// 參考 TAT 實作：需要先取得課程列表，找到對應的 courseValue，然後 POST XML 到 goto_course.php
  Future<bool> _selectCourse(String courseId) async {
    try {
      // Step 1: 取得課程列表頁面
      final response = await _dio.get(
        '${_baseUrl}learn/mooc_sysbar.php',
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
      
      // 檢查是否被重定向（可能 session 失效）
      if (response.statusCode == 302 || response.statusCode == 301) {
        debugPrint('[ISchoolPlus] Session 已失效，需要重新登入');
        return false;
      }
      
      if (response.statusCode != 200) {
        return false;
      }
      
      // Step 2: 解析 HTML 找到課程 value
      final tagNode = html_parser.parse(response.data);
      final selectElement = tagNode.getElementById('selcourse');
      
      if (selectElement == null) {
        debugPrint('[ISchoolPlus] 找不到課程選單元素，可能需要重新登入');
        return false;
      }
      
      final options = selectElement.getElementsByTagName('option');
      String? courseValue;
      
      // 找到對應的課程 ID（格式通常是 XXX_courseId）
      for (int i = 1; i < options.length; i++) {
        final option = options[i];
        final name = option.text.split('_').last.trim();
        
        if (name == courseId) {
          courseValue = option.attributes['value'];
          break;
        }
      }
      
      if (courseValue == null) {
        return false;
      }
      
      // Step 3: POST XML 到 goto_course.php 來選擇課程
      final xml = '<manifest><ticket/><course_id>$courseValue</course_id><env/></manifest>';
      
      final gotoResponse = await _dio.post(
        '${_baseUrl}learn/goto_course.php',
        data: xml,
        options: Options(
          contentType: 'application/xml',
        ),
      );
      
      if (gotoResponse.statusCode != 200) {
        return false;
      }
      
      // 重要：選擇課程後，需要訪問課程首頁來初始化 session
      try {
        await _dio.get('${_baseUrl}learn/index.php');
      } catch (e) {
        return false;
      }
      
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 獲取鎖
  Future<void> _acquireLock() async {
    while (_lock != null) {
      try {
        await _lock!.future;
      } catch (e) {
        // 忽略錯誤，繼續嘗試
      }
    }
    _lock = Completer<void>();
  }

  /// 釋放鎖
  void _releaseLock() {
    if (_lock != null) {
      _lock!.complete();
      _lock = null;
    }
  }

  /// 取得課程公告列表
  Future<List<ISchoolPlusAnnouncement>> getCourseAnnouncements(
      String courseId, {bool highPriority = false}) async {
    await _acquireLock();
    
    try {
      // 先選擇課程
      final selectResult = await _selectCourse(courseId);
      if (!selectResult) {
        return [];
      }

      // Step 1: 取得 bid 和表單資料
      final nodeListResponse = await _dio.post(
        '${_baseUrl}forum/m_node_list.php',
        data: {'cid': '', 'bid': '', 'nid': ''},
      );

      final tagNode = html_parser.parse(nodeListResponse.data);
      final bidElement = tagNode.getElementById('bid');
      // ignore: unused_local_variable
      final bid = bidElement?.attributes['value'] ?? '';

      final formSearch = tagNode.getElementById('formSearch');
      if (formSearch == null) {
        return [];
      }

      final selectPage = tagNode.getElementById('selectPage')?.attributes['value'] ?? '';
      final inputPerPage = tagNode.getElementById('inputPerPage')?.attributes['value'] ?? '';
      final inputs = formSearch.getElementsByTagName('input');
      final Map<String, String> postData = {
        'token': '',
        'bid': '',
        'curtab': '',
        'action': 'getNews',
        'tpc': '1',
        'selectPage': selectPage,
        'inputPerPage': inputPerPage,
      };

      for (final input in inputs) {
        final name = input.attributes['name'];
        final value = input.attributes['value'];
        if (name != null && postData.containsKey(name)) {
          postData[name] = value ?? '';
        }
      }

      final announcementsResponse = await _dio.post(
        '${_baseUrl}mooc/controllers/forum_ajax.php',
        data: postData,
      );

      dynamic jsonData;
      try {
        jsonData = jsonDecode(announcementsResponse.data);
      } catch (e) {
        return [];
      }
      
      final code = jsonData['code'];
      if (code != 0) {
        return [];
      }

      final List<ISchoolPlusAnnouncement> announcements = [];
      final data = jsonData['data'];
      final token = postData['token'];
      
      if (data == null || data is! Map) {
        return [];
      }
      
      final dataMap = data as Map<String, dynamic>;

      for (final entry in dataMap.entries) {
        try {
          final keyParts = entry.key.split('|');
          final announcementData = entry.value as Map<String, dynamic>;
          
          announcements.add(ISchoolPlusAnnouncement.fromJson({
            ...announcementData,
            'bid': keyParts.isNotEmpty ? keyParts.first : '',
            'nid': keyParts.length > 1 ? keyParts.last : '',
            'token': token,
          }));
        } catch (e) {
        }
      }

      return announcements;
    } catch (e) {
      return [];
    } finally {
      _releaseLock();
    }
  }

  Future<ISchoolPlusAnnouncementDetail?> getAnnouncementDetail(
      ISchoolPlusAnnouncement announcement, {required String courseId, bool highPriority = false}) async {
    await _acquireLock();
    
    try {
      final selectResult = await _selectCourse(courseId);
      if (!selectResult) {
        return null;
      }
      
      final data = {
        'token': announcement.token ?? '',
        'cid': announcement.cid ?? '',
        'bid': announcement.bid ?? '',
        'nid': announcement.nid ?? '',
        'mnode': '',
        'subject': '',
        'content': '',
        'awppathre': '',
        'nowpage': '1',
      };

      final response = await _dio.post(
        '${_baseUrl}forum/m_node_chain.php',
        data: data,
      );

      final tagNode = html_parser.parse(response.data);
      final nodeInfo = tagNode.querySelector('.main.node-info');
      if (nodeInfo == null) {
        return null;
      }

      final title = nodeInfo.attributes['data-title'] ?? '';
      final authorName = tagNode.querySelector('.author-name')?.text ?? '';
      final postTime = tagNode.querySelector('.post-time')?.text ?? '';
      final content = tagNode.querySelector('.bottom-tmp .content')?.innerHtml ?? '';

      // 解析附件
      final Map<String, String> files = {};
      final fileElements = tagNode.querySelectorAll('.bottom-tmp .file a');
      for (final fileElement in fileElements) {
        var href = fileElement.attributes['href'] ?? '';
        if (href.startsWith('/')) {
          href = href.substring(1);
        }
        final fileName = fileElement.text;
        files[fileName] = _baseUrl + href;
      }

      return ISchoolPlusAnnouncementDetail(
        title: title,
        sender: authorName,
        postTime: postTime,
        body: content,
        files: files,
      );
    } catch (e) {
      return null;
    } finally {
      _releaseLock();
    }
  }

  Future<List<ISchoolPlusCourseFile>> getCourseFiles(String courseId, {bool highPriority = false}) async {
    await _acquireLock();
    
    try {
      final selectResult = await _selectCourse(courseId);
      if (!selectResult) {
        return [];
      }

      // Step 1: 取得 cid
      final launchResponse = await _dio.get('${_baseUrl}learn/path/launch.php');
      final launchHtml = launchResponse.data.toString();
      
      final Map<String, String> downloadPost = {
        'is_player': '',
        'href': '',
        'prev_href': '',
        'prev_node_id': '',
        'prev_node_title': '',
        'is_download': '',
        'begin_time': '',
        'course_id': '',
        'read_key': '',
      };
      
      if (!(launchHtml.contains('<!DOCTYPE html>') && launchHtml.contains('<html'))) {
        final cidRegex = RegExp(r'cid=([\w|-]+,)');
        final cidMatch = cidRegex.firstMatch(launchHtml);
        if (cidMatch == null) {
          return [];
        }
        final cid = cidMatch.group(1);

        final pathTreeResponse = await _dio.get(
          '${_baseUrl}learn/path/pathtree.php',
          queryParameters: {'cid': cid},
        );
        
        final tagNode = html_parser.parse(pathTreeResponse.data);
        final form = tagNode.getElementById('fetchResourceForm');
        if (form == null) {
          debugPrint('[ISchoolPlus] Fetch resource form not found');
          return [];
        }

        final inputs = form.getElementsByTagName('input');
        for (final input in inputs) {
          final key = input.attributes['name'];
          if (key != null && downloadPost.containsKey(key)) {
            downloadPost[key] = input.attributes['value'] ?? '';
          }
        }
      }

      // Step 3: 取得檔案 XML
      final scormResponse = await _dio.get('${_baseUrl}learn/path/SCORM_loadCA.php');
      final scormData = scormResponse.data.toString();
      
      // 檢查是否返回 HTML（表示沒有教材）
      if (scormData.contains('<!DOCTYPE html>') || scormData.contains('<html')) {
        debugPrint('[ISchoolPlus] SCORM_loadCA.php 返回了 HTML 頁面，此課程可能沒有教材檔案');
        return [];
      }
      
      final scormNode = html_parser.parse(scormResponse.data);
      
      final itemNodes = scormNode.getElementsByTagName('item');
      final resourceNodes = scormNode.getElementsByTagName('resource');

      final List<ISchoolPlusCourseFile> courseFiles = [];

      for (final itemNode in itemNodes) {
        // 跳過目錄 (沒有 identifierref 的項目)
        if (!itemNode.attributes.containsKey('identifierref')) {
          continue;
        }

        final itemId = itemNode.attributes['identifierref'];
        html.Element? matchedResource;
        
        for (final resourceNode in resourceNodes) {
          if (resourceNode.attributes['identifier'] == itemId) {
            matchedResource = resourceNode;
            break;
          }
        }

        if (matchedResource == null) {
          continue;
        }

        final base = matchedResource.attributes['xml:base'] ?? '';
        final href = matchedResource.attributes['href'] ?? '';
        final fullHref = '$base@$href';

        final fileName = itemNode.text.split('\t')[0].replaceAll(RegExp(r'[\s|\n| ]'), '');
        
        final filePostData = Map<String, String>.from(downloadPost);
        filePostData['href'] = fullHref;

        courseFiles.add(ISchoolPlusCourseFile(
          name: fileName,
          fileTypes: [
            FileTypeInfo(
              type: CourseFileType.unknown,
              postData: filePostData,
            ),
          ],
        ));
      }

      debugPrint('[ISchoolPlus] 課程 $courseId 取得 ${courseFiles.length} 個檔案');
      return courseFiles;
    } catch (e) {
      return [];
    } finally {
      _releaseLock();
    }
  }

  /// 取得真實檔案下載網址
  /// 回傳 [實際URL, Referer URL]
  Future<List<String>?> getRealFileUrl(Map<String, String> postParameter) async {
    String url;
    String result = '';
    try {
      final response = await _dio.post(
        '${_baseUrl}learn/path/SCORM_fetchResource.php',
        data: postParameter,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status! < 500,
          headers: {
            'Referer': '${_baseUrl}learn/path/pathtree.php?cid=${postParameter['course_id']}',
          },
        ),
      );

      result = response.data.toString();
      RegExp exp;
      RegExpMatch? matches;
      
      if (response.statusCode == 200) {
        // 檢測網址 "http://....." or 'https://.....' or "http://..." or 'http://...'
        exp = RegExp("[\"'](?<url>https?://.+)[\"']");
        matches = exp.firstMatch(result);
        bool pass = (matches?.groupCount == null)
            ? false
            : matches!.group(1)!.toLowerCase().contains("http")
                ? true
                : false;
        if (pass) {
          url = matches.group(1)!;
          // 已經是完整連結
          return [url, url];
        } else {
          // 檢測 / 開頭網址
          exp = RegExp("\"(?<url>/.+)\"");
          matches = exp.firstMatch(result);
          bool pass = (matches?.groupCount == null) ? false : true;
          if (pass) {
            String realUrl = _baseUrl + matches!.group(1)!;
            return [realUrl, realUrl]; // 一般下載連結
          } else {
            // 檢測""內包含字
            exp = RegExp("\"(?<url>.+)\"");
            matches = exp.firstMatch(result);
            url = "${_baseUrl}learn/path/${matches!.group(1)}"; // 是PDF預覽畫面
            // 去PDF預覽頁面取得真實下載網址
            final previewResponse = await _dio.get(url);
            result = previewResponse.data.toString();
            // 取得PDF真實下載位置
            exp = RegExp("DEFAULT_URL.+['|\"](?<url>.+)['|\"]");
            matches = exp.firstMatch(result);
            String realUrl = "${_baseUrl}learn/path/${matches!.group(1)}";
            return [realUrl, url]; // PDF需要有referer不然會無法下載
          }
        }
      } else if (response.isRedirect == true || result.isEmpty) {
        // 發生跳轉 出現檔案下載預覽頁面
        url = response.headers['location']![0];
        url = "${_baseUrl}learn/path/$url";
        url = url.replaceAll("download_preview", "download"); // 下載預覽頁面換成真實下載網址
        return [url, url];
      }
    } catch (e, stack) {
      debugPrint('[ISchoolPlus] Get real file URL error: $e');
      debugPrint('[ISchoolPlus] StackTrace: $stack');
      debugPrint('[ISchoolPlus] Response: $result');
      return null;
    }
    return null;
  }

  /// 下載檔案
  /// 
  /// [url] 下載網址
  /// [savePath] 儲存路徑回調函數（接收 response headers，返回儲存路徑）
  /// [progressCallback] 進度回調
  /// [cancelToken] 取消 token
  /// [header] 額外的 headers（例如 referer）
  Future<void> download(
    String url,
    String Function(Headers responseHeaders) savePath, {
    required void Function(int count, int total) progressCallback,
    CancelToken? cancelToken,
    Map<String, dynamic>? header,
  }) async {
    debugPrint('[ISchoolPlus] Download URL: $url');
    debugPrint('[ISchoolPlus] Download headers: $header');
    
    // 打印當前的 cookies
    try {
      final uri = Uri.parse(url);
      final cookieManager = _dio.interceptors.whereType<CookieManager>().first;
      final cookies = await cookieManager.cookieJar.loadForRequest(uri);
      debugPrint('[ISchoolPlus] Cookies for ${uri.host}: ${cookies.length} cookies');
      for (final cookie in cookies) {
        debugPrint('[ISchoolPlus] Cookie: ${cookie.name}=${cookie.value.substring(0, cookie.value.length > 20 ? 20 : cookie.value.length)}...');
      }
    } catch (e) {
      debugPrint('[ISchoolPlus] Failed to print cookies: $e');
    }
    
    // 合併默認 headers 和自定義 headers
    final mergedHeaders = Map<String, dynamic>.from(_dio.options.headers);
    if (header != null) {
      mergedHeaders.addAll(header);
    }
    debugPrint('[ISchoolPlus] Merged headers: $mergedHeaders');
    
    await _dio
        .downloadUri(
      Uri.parse(url),
      savePath,
      onReceiveProgress: progressCallback,
      cancelToken: cancelToken,
      options: Options(
        receiveTimeout: const Duration(seconds: 0), // 無超時限制
        headers: mergedHeaders,
      ),
    )
        .catchError(
      (onError, stack) {
        debugPrint('[ISchoolPlus] Download error: $onError');
        debugPrint('[ISchoolPlus] StackTrace: $stack');
        throw onError;
      },
    );
  }
}
