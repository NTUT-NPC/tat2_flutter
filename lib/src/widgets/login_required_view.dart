import 'package:flutter/material.dart';

/// 需要登入的提示視圖
/// 
/// 統一的訪客模式下需要登入功能的UI組件
class LoginRequiredView extends StatelessWidget {
  final String featureName;
  final String? description;
  final VoidCallback? onLoginTap;

  const LoginRequiredView({
    super.key,
    required this.featureName,
    this.description,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              '訪客模式',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              description ?? '$featureName需要登入後才能使用',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onLoginTap,
              icon: const Icon(Icons.login),
              label: const Text('登入'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 帶緩存數據的訪客模式視圖
/// 
/// 用於有緩存數據的功能（如課表(不使用橫幅)、成績、學分）
class GuestModeWithCacheView extends StatelessWidget {
  final String featureName;
  final DateTime? cacheTime;
  final Widget child;
  final VoidCallback? onRefreshTap;

  const GuestModeWithCacheView({
    super.key,
    required this.featureName,
    this.cacheTime,
    required this.child,
    this.onRefreshTap,
  });

  String _formatCacheTime(DateTime cacheTime) {
    final now = DateTime.now();
    final diff = now.difference(cacheTime);

    if (diff.inMinutes < 1) {
      return '剛剛更新';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} 分鐘前更新';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} 小時前更新';
    } else {
      return '${diff.inDays} 天前更新';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 訪客模式橫幅
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.7),
          child: Row(
            children: [
              Icon(
                Icons.cloud_off_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '訪客模式',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (cacheTime != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '緩存資料 · ${_formatCacheTime(cacheTime!)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onRefreshTap != null) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onRefreshTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('登入更新', style: TextStyle(fontSize: 13)),
                ),
              ],
            ],
          ),
        ),
        // 內容
        Expanded(child: child),
      ],
    );
  }
}
