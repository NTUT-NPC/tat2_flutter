import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../src/services/ntut_api_service.dart';
import '../../src/services/auth_service.dart';
import '../../src/providers/auth_provider_v2.dart';
import '../../src/pages/home_page.dart';
import '../../src/pages/privacy_policy_page.dart';
import '../../src/pages/terms_of_service_page.dart';
import '../../src/l10n/app_localizations.dart';

/// 登入畫面
/// 
/// 注意：此畫面沒有 AppBar，因為通常是作為初始頁面或全屏模態頁面使用
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _loadSavedUsername();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 載入已保存的帳號
  Future<void> _loadSavedUsername() async {
    final authService = context.read<AuthService>();
    final credentials = await authService.getSavedCredentials();
    
    if (credentials != null && mounted) {
      _usernameController.text = credentials['studentId'] ?? '';
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseAgreeToTerms),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;
      
      // 檢查是否為測試帳號 (test/password)，自動進入訪客模式
      if (username == 'test' && password == 'password') {
        debugPrint('[Login] 檢測到測試帳號，自動進入訪客模式');
        await _handleGuestMode();
        return;
      }
      
      // 使用 AuthProviderV2 進行登入
      final authProvider = context.read<AuthProviderV2>();
      
      // 登入
      final success = await authProvider.login(
        username: username,
        password: password,
        rememberMe: true,
      );

      if (success) {
        if (mounted) {
          // 檢查是否可以返回上一頁
          final canPop = Navigator.of(context).canPop();
          
          if (canPop) {
            // 有上一頁，返回並傳遞成功標記
            Navigator.of(context).pop(true);
          } else {
            // 沒有上一頁（直接進入登入頁），導航到主頁
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        }
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? l10n.loginFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.loginFailedWithError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 處理訪客模式進入
  Future<void> _handleGuestMode() async {
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.guestModeActivated),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // 檢查是否可以返回上一頁
      final canPop = Navigator.of(context).canPop();
      
      if (canPop) {
        // 有上一頁，返回（不登入，保持訪客模式）
        Navigator.of(context).pop(false);
      } else {
        // 沒有上一頁，導航到主頁（訪客模式）
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo - 暫時移除圖片顯示
                  // Container(
                  //   height: 200,
                  //   padding: const EdgeInsets.symmetric(horizontal: 40),
                  //   child: Image.asset(
                  //     isDarkMode 
                  //       ? 'assets/images/splash-dark.png'
                  //       : 'assets/images/splash.png',
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  const SizedBox(height: 80),

                  // 標題
                  Text(
                    AppLocalizations.of(context).appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 48),

                  // 學號輸入
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context);
                      return TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: l10n.studentId,
                          hintText: l10n.pleaseEnterStudentId,
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterStudentId;
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 密碼輸入
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context);
                      return TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          hintText: l10n.pleaseEnterPassword,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterPassword;
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 同意條款 Checkbox
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context);
                      return Row(
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreedToTerms = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _agreedToTerms = !_agreedToTerms;
                                });
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodySmall,
                                  children: [
                                    TextSpan(text: l10n.agreeToTerms),
                                    TextSpan(
                                      text: l10n.privacyPolicy,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const PrivacyPolicyPage(),
                                            ),
                                          );
                                        },
                                    ),
                                    TextSpan(text: l10n.and),
                                    TextSpan(
                                      text: l10n.termsOfService,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const TermsOfServicePage(),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 登入按鈕
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context);
                      return FilledButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                l10n.login,
                                style: const TextStyle(fontSize: 16),
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // 訪客模式按鈕
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context);
                      return OutlinedButton(
                        onPressed: _isLoading ? null : _handleGuestMode,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 8),
                            Text(
                              l10n.browseAsGuest,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
