import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_credential.dart';
import 'auth_result.dart';
import '../adapter/school_adapter.dart';

/// 登入狀態枚舉
enum AuthState {
  /// 未初始化
  unknown,
  
  /// 訪客模式（未登入，可以使用本地緩存和離線功能）
  guest,
  
  /// 離線模式（已登入但網路不可用或 Session 過期，使用緩存數據）
  offline,
  
  /// 正在登入
  loggingIn,
  
  /// 已登入且 Session 有效
  authenticated,
  
  /// Session 已過期（靜默重試中）
  sessionExpired,
}

/// 認證管理器 - 統一管理所有學校的認證狀態
/// 
/// 職責：
/// 1. 管理本地憑證儲存
/// 2. 協調學校 Adapter 進行登入
/// 3. 管理登入狀態（支援離線模式）
/// 4. 提供自動重新登入機制
/// 5. Session 自動刷新（30分鐘）
class AuthManager {
  static const String _keyUsername = 'auth_username';
  static const String _keyPassword = 'auth_password';
  static const String _keyRememberMe = 'auth_remember_me';
  static const String _keyIsLoggedIn = 'auth_is_logged_in';
  static const String _keyLastLoginTime = 'auth_last_login_time';
  
  // Session 超時時間：30分鐘
  static const Duration sessionTimeout = Duration(minutes: 30);
  // 自動刷新間隔：25分鐘（比超時時間短，確保在過期前刷新）
  static const Duration autoRefreshInterval = Duration(minutes: 25);
  
  final SchoolAdapter _adapter;
  
  AuthCredential? _currentCredential;
  bool _isLoggedIn = false;
  DateTime? _lastLoginTime;
  Timer? _autoRefreshTimer;
  bool _isRefreshing = false;
  AuthState _authState = AuthState.unknown;

  AuthManager(this._adapter) {
    _initializeFromStorage();
  }

  /// 當前認證狀態
  AuthState get authState => _authState;
  
  /// 是否已登入（Session 有效）
  bool get isLoggedIn => _isLoggedIn && _adapter.isLoggedIn;
  
  /// 是否為訪客模式（從未登入）
  bool get isGuestMode => _authState == AuthState.guest;
  
  /// 是否為離線模式（已登入但 Session 失效，使用緩存）
  bool get isOfflineMode => _authState == AuthState.offline;
  
  /// 是否可以使用緩存數據（訪客模式或離線模式）
  bool get canUseCachedData => isGuestMode || isOfflineMode || isLoggedIn;

  /// 當前憑證
  AuthCredential? get currentCredential => _currentCredential;

  /// 最後登入時間
  DateTime? get lastLoginTime => _lastLoginTime;

  /// Session 是否可能已過期（距離上次登入超過30分鐘）
  bool get isSessionLikelyExpired {
    if (_lastLoginTime == null) return true;
    final elapsed = DateTime.now().difference(_lastLoginTime!);
    return elapsed >= sessionTimeout;
  }

  /// 從本地儲存初始化狀態（用於 App 重啟後恢復狀態）
  Future<void> _initializeFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 恢復登入狀態
      _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      
      // 恢復最後登入時間
      final lastLoginTimestamp = prefs.getInt(_keyLastLoginTime);
      if (lastLoginTimestamp != null) {
        _lastLoginTime = DateTime.fromMillisecondsSinceEpoch(lastLoginTimestamp);
      }
      
      // 如果曾經登入過，恢復憑證
      if (_isLoggedIn) {
        _currentCredential = await loadCredentials();
        
        // 檢查 session 是否可能過期
        if (isSessionLikelyExpired) {
          debugPrint('[AuthManager] Session 可能已過期，設為離線模式（使用緩存）');
          _authState = AuthState.offline;
          // 靜默嘗試刷新，不阻塞用戶使用
          _tryAutoRefresh();
        } else {
          _authState = AuthState.authenticated;
          // 啟動自動刷新計時器
          _startAutoRefreshTimer();
          debugPrint('[AuthManager] 已恢復登入狀態: ${_currentCredential?.username}');
        }
      } else {
        // 從未登入過，進入訪客模式
        _authState = AuthState.guest;
        debugPrint('[AuthManager] 初始化為訪客模式');
      }
    } catch (e) {
      debugPrint('[AuthManager] 初始化失敗: $e');
      _authState = AuthState.offline;
    }
  }

  /// 保存登入狀態到本地
  Future<void> _saveLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, _isLoggedIn);
      
      if (_lastLoginTime != null) {
        await prefs.setInt(_keyLastLoginTime, _lastLoginTime!.millisecondsSinceEpoch);
      } else {
        await prefs.remove(_keyLastLoginTime);
      }
    } catch (e) {
      debugPrint('[AuthManager] 保存登入狀態失敗: $e');
    }
  }

  /// 保存憑證到本地
  Future<void> saveCredentials(AuthCredential credential) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, credential.username);
    await prefs.setString(_keyPassword, credential.password);
    await prefs.setBool(_keyRememberMe, true);
    debugPrint('[AuthManager] 已保存憑證: ${credential.username}');
  }

  /// 從本地讀取憑證
  Future<AuthCredential?> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
    
    if (!rememberMe) {
      return null;
    }
    
    final username = prefs.getString(_keyUsername);
    final password = prefs.getString(_keyPassword);
    
    if (username != null && password != null) {
      debugPrint('[AuthManager] 找到已保存的憑證: $username');
      return AuthCredential(username: username, password: password);
    }
    
    return null;
  }

  /// 清除本地憑證
  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPassword);
    await prefs.setBool(_keyRememberMe, false);
    _currentCredential = null;
    debugPrint('[AuthManager] 已清除本地憑證');
  }

  /// 登入
  Future<AuthResult> login(AuthCredential credential, {bool saveCredentials = true}) async {
    try {
      debugPrint('[AuthManager] 開始登入: ${credential.username}');
      _authState = AuthState.loggingIn;
      
      final result = await _adapter.login(credential);
      
      if (result.success) {
        _isLoggedIn = true;
        _currentCredential = credential;
        _lastLoginTime = DateTime.now();
        _authState = AuthState.authenticated;
        
        if (saveCredentials) {
          await this.saveCredentials(credential);
        }
        
        // 保存登入狀態
        await _saveLoginState();
        
        // 啟動自動刷新計時器
        _startAutoRefreshTimer();
        
        debugPrint('[AuthManager] 登入成功: ${credential.username}');
      } else {
        // 登入失敗，但不清除本地狀態，保持訪客/離線模式
        if (_currentCredential == null) {
          _authState = AuthState.guest;
        } else {
          _authState = AuthState.offline;
        }
        debugPrint('[AuthManager] 登入失敗: ${result.message}');
      }
      
      return result;
    } catch (e) {
      // 登入異常，保持當前狀態
      if (_currentCredential == null) {
        _authState = AuthState.guest;
      } else {
        _authState = AuthState.offline;
      }
      debugPrint('[AuthManager] 登入錯誤: $e');
      return AuthResult.failure(message: '登入錯誤: $e');
    }
  }

  /// 嘗試自動登入（使用本地保存的憑證）
  Future<AuthResult?> tryAutoLogin() async {
    // 防止重複登入
    if (_isRefreshing) {
      debugPrint('[AuthManager] 正在登入中，跳過重複的自動登入請求');
      await Future.delayed(const Duration(milliseconds: 500));
      return _isLoggedIn ? AuthResult.success() : null;
    }
    
    debugPrint('[AuthManager] 嘗試自動登入');
    
    final credential = await loadCredentials();
    if (credential == null) {
      debugPrint('[AuthManager] 沒有保存的憑證');
      return null;
    }
    
    _isRefreshing = true;
    try {
      final result = await login(credential, saveCredentials: false);
      
      // 如果登入失敗
      if (!result.success) {
        final errorMsg = result.message ?? '';
        
        // 如果是帳密錯誤，清除本地憑證
        if (errorMsg.contains('帳號或密碼')) {
          await clearCredentials();
        }
        
        // 如果是網路錯誤，保持離線模式，不清除憑證
        if (errorMsg.contains('connection') ||
            errorMsg.contains('host lookup') ||
            errorMsg.contains('network') ||
            errorMsg.contains('timeout') ||
            errorMsg.contains('Socket')) {
          debugPrint('[AuthManager] 網路連接失敗，保持離線模式（可使用緩存）');
          _authState = AuthState.offline;
        }
      }
      
      return result;
    } finally {
      _isRefreshing = false;
    }
  }

  /// 重新登入（使用當前憑證）
  /// 
  /// 用於 Session 過期時自動重新登入
  Future<AuthResult> relogin() async {
    if (_isRefreshing) {
      debugPrint('[AuthManager] 正在刷新中，跳過重複的重新登入請求');
      // 等待當前刷新完成
      await Future.delayed(const Duration(seconds: 1));
      return AuthResult.success(message: '等待刷新完成');
    }
    
    _isRefreshing = true;
    
    try {
      if (_currentCredential == null) {
        // 嘗試從本地載入憑證
        final credential = await loadCredentials();
        if (credential == null) {
          return AuthResult.failure(message: '沒有可用的憑證，請重新登入');
        }
        _currentCredential = credential;
      }
      
      debugPrint('[AuthManager] 使用當前憑證重新登入: ${_currentCredential!.username}');
      final result = await login(_currentCredential!, saveCredentials: false);
      return result;
    } finally {
      _isRefreshing = false;
    }
  }

  /// 啟動自動刷新計時器
  void _startAutoRefreshTimer() {
    // 先停止舊的計時器
    _stopAutoRefreshTimer();
    
    debugPrint('[AuthManager] 啟動自動刷新計時器（${autoRefreshInterval.inMinutes} 分鐘後刷新）');
    
    _autoRefreshTimer = Timer.periodic(autoRefreshInterval, (timer) async {
      debugPrint('[AuthManager] 自動刷新 Session');
      await _tryAutoRefresh();
    });
  }

  /// 停止自動刷新計時器
  void _stopAutoRefreshTimer() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  /// 嘗試自動刷新 Session（靜默重試，不打斷用戶）
  Future<void> _tryAutoRefresh() async {
    if (_currentCredential == null) {
      debugPrint('[AuthManager] 無憑證，跳過自動刷新');
      return;
    }
    
    if (_isRefreshing) {
      debugPrint('[AuthManager] 正在刷新中，跳過重複的刷新請求');
      return;
    }
    
    try {
      debugPrint('[AuthManager] 靜默嘗試刷新 Session');
      _authState = AuthState.sessionExpired; // 標記為刷新中
      
      final result = await relogin();
      
      if (result.success) {
        debugPrint('[AuthManager] Session 自動刷新成功');
        _authState = AuthState.authenticated;
      } else {
        debugPrint('[AuthManager] Session 自動刷新失敗: ${result.message}');
        // 刷新失敗，進入離線模式（用戶可繼續使用緩存數據）
        _authState = AuthState.offline;
      }
    } catch (e) {
      debugPrint('[AuthManager] Session 自動刷新異常: $e');
      // 異常情況進入離線模式，不強制登出，用戶可使用緩存
      _authState = AuthState.offline;
    }
  }

  /// 登出
  /// 
  /// [clearLocalCredentials] 是否清除本地憑證（預設不清除，方便下次登入）
  /// [clearCache] 是否清除緩存數據（預設不清除，訪客模式仍可查看）
  Future<void> logout({
    bool clearLocalCredentials = false,
    bool clearCache = false,
  }) async {
    debugPrint('[AuthManager] 登出 (清除憑證: $clearLocalCredentials, 清除緩存: $clearCache)');
    
    // 停止自動刷新計時器
    _stopAutoRefreshTimer();
    
    await _adapter.logout();
    _isLoggedIn = false;
    _lastLoginTime = null;
    
    // 登出後進入訪客模式（仍可使用緩存數據）
    _authState = AuthState.guest;
    
    // 清除登入狀態
    await _saveLoginState();
    
    if (clearLocalCredentials) {
      await clearCredentials();
      _currentCredential = null;
    }
    
    // 注意：不在這裡清除緩存，緩存由 CacheManager 統一管理
    // 用戶可以在訪客模式下繼續查看緩存的課表、成績等
    debugPrint('[AuthManager] 已登出，進入訪客模式');
  }

  /// 檢查 Session 是否有效
  Future<bool> checkSession() async {
    final isValid = await _adapter.checkSession();
    
    // 如果 session 無效且有憑證，嘗試自動刷新
    if (!isValid && _currentCredential != null) {
      debugPrint('[AuthManager] Session 無效，嘗試自動刷新');
      await _tryAutoRefresh();
      return await _adapter.checkSession();
    }
    
    return isValid;
  }

  /// 清理資源（App 關閉時調用）
  void dispose() {
    _stopAutoRefreshTimer();
    debugPrint('[AuthManager] 已釋放資源');
  }
}
