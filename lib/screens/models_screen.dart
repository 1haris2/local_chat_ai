import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../viewmodels/model_viewmodel.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../widgets/model_card.dart';

class ModelsScreen extends StatelessWidget {
  const ModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Models',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.accentPurple.withAlpha(30),
                      AppTheme.bgDark,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Info card
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentPurple.withAlpha(40)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppTheme.accentPurple,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Download a model to start chatting. Tap a downloaded model to make it active.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Model list
          Consumer<ModelViewModel>(
            builder: (context, modelVm, _) {
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final model = modelVm.availableModels[index];
                  final status = modelVm.getDownloadStatus(model.id);
                  final progress = modelVm.getDownloadProgress(model.id);
                  final isActive = modelVm.activeModelId == model.id;

                  return ModelCard(
                    model: model,
                    status: status,
                    progress: progress,
                    isActive: isActive,
                    onDownload: () => modelVm.downloadModel(model.id),
                    onCancel: () => modelVm.cancelDownload(model.id),
                    onDelete: () => _showDeleteDialog(
                      context,
                      modelVm,
                      model.id,
                      model.name,
                    ),
                    onSelect: () async {
                      await modelVm.setActiveModel(model.id);
                      // Load the model into the chat engine
                      final path = await modelVm.getModelPath(model.id);
                      if (path != null && context.mounted) {
                        final chatVm = context.read<ChatViewModel>();
                        await chatVm.loadModel(path);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${model.name} is now active'),
                              backgroundColor: AppTheme.accentGreen,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  );
                }, childCount: modelVm.availableModels.length),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    ModelViewModel modelVm,
    String modelId,
    String modelName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete $modelName?',
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'This will remove the model file from your device. You can re-download it later.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              modelVm.deleteModel(modelId);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
