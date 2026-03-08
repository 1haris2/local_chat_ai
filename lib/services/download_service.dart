import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadProgress {
  final double progress; // 0.0 to 1.0
  final int received;
  final int total;
  final double speedBytesPerSec;

  DownloadProgress({
    required this.progress,
    required this.received,
    required this.total,
    this.speedBytesPerSec = 0,
  });

  String get speedFormatted {
    if (speedBytesPerSec > 1024 * 1024) {
      return '${(speedBytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
    return '${(speedBytesPerSec / 1024).toStringAsFixed(0)} KB/s';
  }

  String get receivedFormatted {
    final mb = received / (1024 * 1024);
    if (mb >= 1024) {
      return '${(mb / 1024).toStringAsFixed(1)} GB';
    }
    return '${mb.toStringAsFixed(0)} MB';
  }

  String get totalFormatted {
    final mb = total / (1024 * 1024);
    if (mb >= 1024) {
      return '${(mb / 1024).toStringAsFixed(1)} GB';
    }
    return '${mb.toStringAsFixed(0)} MB';
  }
}

class DownloadService {
  final Dio _dio = Dio();
  CancelToken? _cancelToken;

  Future<String> getModelsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelsDir = Directory('${appDir.path}/models');
    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }
    return modelsDir.path;
  }

  Future<String?> downloadModel({
    required String url,
    required String fileName,
    required Function(DownloadProgress) onProgress,
    required Function() onComplete,
    required Function(String error) onError,
  }) async {
    _cancelToken = CancelToken();
    final modelsDir = await getModelsDirectory();
    final filePath = '$modelsDir/$fileName';
    final tempPath = '$filePath.tmp';

    try {
      DateTime lastTime = DateTime.now();
      int lastReceived = 0;

      await _dio.download(
        url,
        tempPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total <= 0) return;

          final now = DateTime.now();
          final elapsed = now.difference(lastTime).inMilliseconds;
          double speed = 0;
          if (elapsed > 500) {
            speed = (received - lastReceived) / (elapsed / 1000);
            lastTime = now;
            lastReceived = received;
          }

          onProgress(
            DownloadProgress(
              progress: received / total,
              received: received,
              total: total,
              speedBytesPerSec: speed,
            ),
          );
        },
      );

      // Rename temp file to final
      final tempFile = File(tempPath);
      await tempFile.rename(filePath);

      onComplete();
      return filePath;
    } on DioException catch (e) {
      // Clean up temp file
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      if (e.type == DioExceptionType.cancel) {
        onError('Download cancelled');
      } else {
        onError('Download failed: ${e.message}');
      }
      return null;
    } catch (e) {
      onError('Download failed: $e');
      return null;
    }
  }

  void cancelDownload() {
    _cancelToken?.cancel('User cancelled');
  }

  Future<bool> isModelDownloaded(String fileName) async {
    final modelsDir = await getModelsDirectory();
    final file = File('$modelsDir/$fileName');
    return file.exists();
  }

  Future<String?> getModelPath(String fileName) async {
    final modelsDir = await getModelsDirectory();
    final filePath = '$modelsDir/$fileName';
    final file = File(filePath);
    if (await file.exists()) {
      return filePath;
    }
    return null;
  }

  Future<void> deleteModel(String fileName) async {
    final modelsDir = await getModelsDirectory();
    final file = File('$modelsDir/$fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
