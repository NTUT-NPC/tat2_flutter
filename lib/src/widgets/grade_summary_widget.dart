import 'package:flutter/material.dart';
import '../models/semester_grade_stats.dart';
import '../l10n/app_localizations.dart';

/// 學期成績統計 Widget
class GradeSummaryWidget extends StatelessWidget {
  final SemesterGradeStats stats;
  final String? title;

  const GradeSummaryWidget({
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
            
            // 平均成績和學分
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: l10n.averageScore,
                    value: stats.averageScoreString,
                    icon: Icons.star,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatItem(
                    label: l10n.takenCredits,
                    value: stats.totalCreditsString,
                    icon: Icons.book,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 獲得學分和課程數
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: l10n.obtainedCredits,
                    value: stats.earnedCreditsString,
                    icon: Icons.check_circle,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatItem(
                    label: l10n.courseCount,
                    value: '${stats.passedCourses}/${stats.totalCourses}',
                    icon: Icons.assignment,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            
            // 不及格提示
            if (stats.failedCourses > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, 
                      color: Theme.of(context).colorScheme.error, 
                      size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.failedCoursesCount(stats.failedCourses),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

/// 整體成績統計 Widget（所有學期）
class OverallGradeSummaryWidget extends StatelessWidget {
  final double overallAverage;
  final double totalCredits;
  final RankInfo? overallClassRank;
  final RankInfo? overallDeptRank;

  const OverallGradeSummaryWidget({
    super.key,
    required this.overallAverage,
    required this.totalCredits,
    this.overallClassRank,
    this.overallDeptRank,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              l10n.overallStats,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _OverallStatItem(
                  label: l10n.overallGpa,
                  value: overallAverage.toStringAsFixed(2),
                  icon: Icons.emoji_events,
                ),
                _OverallStatItem(
                  label: l10n.totalCredits,
                  value: totalCredits.toStringAsFixed(0),
                  icon: Icons.school,
                ),
              ],
            ),
            if (overallClassRank != null || overallDeptRank != null) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                l10n.overallRank,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (overallClassRank != null)
                    _OverallRankItem(
                      label: l10n.classRankFull,
                      rank: overallClassRank!,
                      icon: Icons.class_,
                    ),
                  if (overallDeptRank != null)
                    _OverallRankItem(
                      label: l10n.departmentRankFull,
                      rank: overallDeptRank!,
                      icon: Icons.school,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OverallStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _OverallStatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _OverallRankItem extends StatelessWidget {
  final String label;
  final RankInfo rank;
  final IconData icon;

  const _OverallRankItem({
    required this.label,
    required this.rank,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final rankColor = colorScheme.tertiary;
    
    return Column(
      children: [
        Icon(icon, size: 28, color: rankColor),
        const SizedBox(height: 8),
        Text(
          rank.rankString,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          l10n.topPercentage(rank.percentage.toStringAsFixed(1)),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
