import 'package:flutter/material.dart';
import '../models/model_info.dart';
import '../services/download_service.dart';
import '../theme/app_theme.dart';

class ModelCard extends StatelessWidget {
  final ModelInfo model;
  final DownloadStatus status;
  final DownloadProgress? progress;
  final bool isActive;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  const ModelCard({
    super.key,
    required this.model,
    required this.status,
    this.progress,
    required this.isActive,
    required this.onDownload,
    required this.onCancel,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppTheme.accentPurple.withAlpha(150)
              : AppTheme.borderColor,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppTheme.accentPurple.withAlpha(30),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: status == DownloadStatus.downloaded ? onSelect : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Model icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Model info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  model.name,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isActive) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentGreen.withAlpha(40),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'ACTIVE',
                                    style: TextStyle(
                                      color: AppTheme.accentGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${model.parameterSize} · ${model.quantization} · ${model.fileSizeFormatted}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action button
                    _buildActionButton(),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  model.description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                if (status == DownloadStatus.downloading &&
                    progress != null) ...[
                  const SizedBox(height: 12),
                  _buildProgressBar(),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.memory_rounded,
                      size: 14,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Needs ${model.recommendedRamGb}GB+ RAM',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    if (status == DownloadStatus.downloaded) ...[
                      const Spacer(),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 14,
                              color: AppTheme.error,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: AppTheme.error,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        return Container(
          decoration: BoxDecoration(
            gradient: AppTheme.accentGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onDownload,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case DownloadStatus.downloading:
        return IconButton(
          onPressed: onCancel,
          icon: const Icon(Icons.close_rounded, color: AppTheme.error),
          tooltip: 'Cancel download',
        );
      case DownloadStatus.downloaded:
        if (isActive) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.accentGreen,
              size: 20,
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: AppTheme.bgSurface,
              border: Border.all(color: AppTheme.accentPurple),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onSelect,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        color: AppTheme.accentPurple,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Select',
                        style: TextStyle(
                          color: AppTheme.accentPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress!.progress,
            backgroundColor: AppTheme.bgDark,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.accentPurple,
            ),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${progress!.receivedFormatted} / ${progress!.totalFormatted}',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
            ),
            Text(
              '${(progress!.progress * 100).toStringAsFixed(1)}%',
              style: const TextStyle(
                color: AppTheme.accentPurple,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
