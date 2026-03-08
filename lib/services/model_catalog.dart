import '../models/model_info.dart';

class ModelCatalog {
  static const List<ModelInfo> availableModels = [
    ModelInfo(
      id: 'qwen3.5-0.8b-q4',
      name: 'Qwen 3.5 0.8B',
      description:
          'Lightweight & fast. Great for quick responses on any device. Low resource usage, ideal for phones with 4GB+ RAM.',
      fileName: 'Qwen3.5-0.8B-Q4_K_M.gguf',
      downloadUrl:
          'https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF/resolve/main/Qwen3.5-0.8B-Q4_K_M.gguf',
      fileSizeBytes: 630000000, // ~600 MB
      quantization: 'Q4_K_M',
      family: 'Qwen 3.5',
      parameterSize: '0.8B',
      recommendedRamGb: 3,
    ),
    ModelInfo(
      id: 'qwen3.5-2b-q4',
      name: 'Qwen 3.5 2B',
      description:
          'Balanced quality & speed. Significantly smarter responses while still running smoothly. Needs 6GB+ RAM.',
      fileName: 'Qwen3.5-2B-Q4_K_M.gguf',
      downloadUrl:
          'https://huggingface.co/unsloth/Qwen3.5-2B-GGUF/resolve/main/Qwen3.5-2B-Q4_K_M.gguf',
      fileSizeBytes: 1500000000, // ~1.5 GB
      quantization: 'Q4_K_M',
      family: 'Qwen 3.5',
      parameterSize: '2B',
      recommendedRamGb: 6,
    ),
    ModelInfo(
      id: 'qwen2.5-1.5b-abliterated-q4',
      name: 'Qwen 2.5 1.5B (Uncensored)',
      description:
          'Uncensored (Abliterated) Qwen 2.5. Highly capable, refuses fewer prompts. Good middle-ground for memory.',
      fileName: 'Qwen2.5-1.5B-Instruct-abliterated.i1-Q4_K_M.gguf',
      downloadUrl:
          'https://huggingface.co/mradermacher/Qwen2.5-1.5B-Instruct-abliterated-i1-GGUF/resolve/main/Qwen2.5-1.5B-Instruct-abliterated.i1-Q4_K_M.gguf',
      fileSizeBytes: 1120000000, // ~1.12 GB
      quantization: 'Q4_K_M',
      family: 'Qwen 2.5',
      parameterSize: '1.5B',
      recommendedRamGb: 4,
    ),
    ModelInfo(
      id: 'llama-3.2-1b-instruct-q4',
      name: 'Llama 3.2 1B Instruct',
      description:
          'Meta\'s lightweight Llama 3.2. Excellent command of English and fast responses. Very memory efficient.',
      fileName: 'Llama-3.2-1B-Instruct-Q4_K_M.gguf',
      downloadUrl:
          'https://huggingface.co/bartowski/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-Q4_K_M.gguf',
      fileSizeBytes: 890000000, // ~890 MB
      quantization: 'Q4_K_M',
      family: 'Llama 3',
      parameterSize: '1B',
      recommendedRamGb: 3,
    ),
    ModelInfo(
      id: 'llama-3.2-3b-instruct-q4',
      name: 'Llama 3.2 3B Instruct',
      description:
          'Considerably smarter than 1B. Top-tier reasoning and English writing capabilities for mobile.',
      fileName: 'Llama-3.2-3B-Instruct-Q4_K_M.gguf',
      downloadUrl:
          'https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf',
      fileSizeBytes: 2010000000, // ~2.01 GB
      quantization: 'Q4_K_M',
      family: 'Llama 3',
      parameterSize: '3B',
      recommendedRamGb: 6,
    ),
    ModelInfo(
      id: 'qwen2.5-3b-instruct-q4',
      name: 'Qwen 2.5 3B Instruct',
      description:
          'Top-tier reasoning and coding capabilities for its size. High quality responses suitable for many tasks.',
      fileName: 'Qwen2.5-3B-Instruct-Q4_K_M.gguf',
      downloadUrl:
          'https://huggingface.co/bartowski/Qwen2.5-3B-Instruct-GGUF/resolve/main/Qwen2.5-3B-Instruct-Q4_K_M.gguf',
      fileSizeBytes: 1980000000, // ~1.98 GB
      quantization: 'Q4_K_M',
      family: 'Qwen 2.5',
      parameterSize: '3B',
      recommendedRamGb: 6,
    ),
    ModelInfo(
      id: 'qwen3.5-4b-q4',
      name: 'Qwen 3.5 4B',
      description:
          'Excellent capabilities in coding and reasoning. Balanced speed and quality. Needs 6GB+ RAM.',
      fileName: 'Qwen3.5-4B-Q4_K_M.gguf',
      downloadUrl:
          'https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-Q4_K_M.gguf',
      fileSizeBytes: 2600000000, // ~2.6 GB
      quantization: 'Q4_K_M',
      family: 'Qwen 3.5',
      parameterSize: '4B',
      recommendedRamGb: 6,
    ),
    ModelInfo(
      id: 'qwen2.5-0.5b-abliterated-v3-q8',
      name: 'Qwen 2.5 0.5B (Uncensored)',
      description:
          'Tiny, uncensored, and extremely fast. Excellent for english writing and logic on constrained memory devices.',
      fileName: 'Qwen2.5-0.5B-Instruct-abliterated-v3.Q8_0.gguf',
      downloadUrl:
          'https://huggingface.co/mradermacher/Qwen2.5-0.5B-Instruct-abliterated-v3-GGUF/resolve/main/Qwen2.5-0.5B-Instruct-abliterated-v3.Q8_0.gguf',
      fileSizeBytes: 530000000, // ~530 MB
      quantization: 'Q8_0',
      family: 'Qwen 2.5',
      parameterSize: '0.5B',
      recommendedRamGb: 2,
    ),
  ];
}
