enum DownloadStatus { notDownloaded, downloading, paused, downloaded }

class ModelInfo {
  final String id;
  final String name;
  final String description;
  final String fileName;
  final String downloadUrl;
  final int fileSizeBytes;
  final String quantization;
  final String family;
  final String parameterSize;
  final int recommendedRamGb;

  const ModelInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.fileName,
    required this.downloadUrl,
    required this.fileSizeBytes,
    required this.quantization,
    required this.family,
    required this.parameterSize,
    required this.recommendedRamGb,
  });

  String get fileSizeFormatted {
    final gb = fileSizeBytes / (1024 * 1024 * 1024);
    if (gb >= 1) {
      return '${gb.toStringAsFixed(1)} GB';
    }
    final mb = fileSizeBytes / (1024 * 1024);
    return '${mb.toStringAsFixed(0)} MB';
  }
}
