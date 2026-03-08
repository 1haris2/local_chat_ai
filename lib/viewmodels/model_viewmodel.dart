import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model_info.dart';
import '../services/model_catalog.dart';
import '../services/download_service.dart';

class ModelViewModel extends ChangeNotifier {
  final DownloadService _downloadService = DownloadService();

  List<ModelInfo> get availableModels => ModelCatalog.availableModels;

  final Map<String, DownloadStatus> _downloadStatuses = {};
  final Map<String, DownloadProgress> _downloadProgresses = {};
  String? _activeModelId;

  String? get activeModelId => _activeModelId;

  ModelViewModel() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _activeModelId = prefs.getString('active_model_id');

    // Check which models are downloaded
    for (final model in availableModels) {
      final isDownloaded = await _downloadService.isModelDownloaded(
        model.fileName,
      );
      _downloadStatuses[model.id] = isDownloaded
          ? DownloadStatus.downloaded
          : DownloadStatus.notDownloaded;
    }
    notifyListeners();
  }

  DownloadStatus getDownloadStatus(String modelId) {
    return _downloadStatuses[modelId] ?? DownloadStatus.notDownloaded;
  }

  DownloadProgress? getDownloadProgress(String modelId) {
    return _downloadProgresses[modelId];
  }

  ModelInfo? get activeModel {
    if (_activeModelId == null) return null;
    try {
      return availableModels.firstWhere((m) => m.id == _activeModelId);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getModelPath(String modelId) async {
    final model = availableModels.firstWhere((m) => m.id == modelId);
    return _downloadService.getModelPath(model.fileName);
  }

  Future<void> downloadModel(String modelId) async {
    final model = availableModels.firstWhere((m) => m.id == modelId);

    _downloadStatuses[modelId] = DownloadStatus.downloading;
    notifyListeners();

    await _downloadService.downloadModel(
      url: model.downloadUrl,
      fileName: model.fileName,
      onProgress: (progress) {
        _downloadProgresses[modelId] = progress;
        notifyListeners();
      },
      onComplete: () {
        _downloadStatuses[modelId] = DownloadStatus.downloaded;
        _downloadProgresses.remove(modelId);
        notifyListeners();
      },
      onError: (error) {
        _downloadStatuses[modelId] = DownloadStatus.notDownloaded;
        _downloadProgresses.remove(modelId);
        debugPrint('Download error: $error');
        notifyListeners();
      },
    );
  }

  void cancelDownload(String modelId) {
    _downloadService.cancelDownload();
    _downloadStatuses[modelId] = DownloadStatus.notDownloaded;
    _downloadProgresses.remove(modelId);
    notifyListeners();
  }

  Future<void> deleteModel(String modelId) async {
    final model = availableModels.firstWhere((m) => m.id == modelId);
    await _downloadService.deleteModel(model.fileName);
    _downloadStatuses[modelId] = DownloadStatus.notDownloaded;

    if (_activeModelId == modelId) {
      _activeModelId = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('active_model_id');
    }
    notifyListeners();
  }

  Future<void> setActiveModel(String modelId) async {
    _activeModelId = modelId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_model_id', modelId);
    notifyListeners();
  }
}
