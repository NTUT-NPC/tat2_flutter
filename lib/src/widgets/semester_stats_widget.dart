import 'package:flutter/material.dart';
import '../models/semester_grade_stats.dart';
import '../l10n/app_localizations.dart';

/// 學期統計 Widget（包含排名和操行成績）
class SemesterStatsWidget extends StatelessWidget {
  final SemesterGradeStats stats;
  final String? title;

  const SemesterStatsWidget({
    super.key,
    required this.stats,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 16),
            ],
            
            // 平均成績和操行成績
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: l10n.averageScore,
                    value: stats.averageScore.toStringAsFixed(2),
                    icon: Icons.star,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: stats.performanceScore != null
                      ? _StatItem(
                          label: l10n.performanceScore,
                          value: stats.performanceScore!.toStringAsFixed(0),
                          icon: Icons.person,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : _StatItem(
                          label: l10n.performanceScore,
                          value: '-',
                          icon: Icons.person,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 修習學分和獲得學分
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: l10n.takenCredits,
                    value: stats.totalCredits.toStringAsFixed(1),
                    icon: Icons.book,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatItem(
                    label: l10n.obtainedCredits,
                    value: stats.earnedCredits.toStringAsFixed(1),
                    icon: Icons.check_circle,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            
            // 排名信息
            if (stats.classRank != null || stats.departmentRank != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                l10n.rank,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
            ],
            
            // 班排名和系排名
            if (stats.classRank != null || stats.departmentRank != null)
              Row(
                children: [
                  if (stats.classRank != null)
                    Expanded(
                      child: _RankItem(
                        label: l10n.classRankFull,
                        rank: stats.classRank!,
                        icon: Icons.class_,
                      ),
                    ),
                  if (stats.classRank != null && stats.departmentRank != null)
                    const SizedBox(width: 16),
                  if (stats.departmentRank != null)
                    Expanded(
                      child: _RankItem(
                        label: l10n.departmentRankFull,
                        rank: stats.departmentRank!,
                        icon: Icons.school,
                      ),
                    ),
                  if (stats.classRank == null && stats.departmentRank != null)
                    const Expanded(child: SizedBox()),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// 單個統計項目
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

/// 排名項目
class _RankItem extends StatelessWidget {
  final String label;
  final RankInfo rank;
  final IconData icon;

  const _RankItem({
    required this.label,
    required this.rank,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rankColor = colorScheme.tertiary;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rankColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rankColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: rankColor, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: rankColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rank.rankString,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: rankColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '前 ${rank.percentage.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
