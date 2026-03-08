# Local Chat AI 🤖

A powerful, privacy-focused, and completely offline AI chat application built with Flutter. Run state-of-the-art Large Language Models (LLMs) like Llama 3 and Qwen directly on your device—no internet connection required!

Created by **Haris**.

## 🌟 Key Features

- **100% Offline Inference:** Chat securely without your data ever leaving your device.
- **Built-in Model Downloader:** Easily browse, download, and manage advanced open-source models (GGUF format).
- **Curated Model Selection:** Includes optimized models like:
  - Llama 3.2 (1B and 3B Instruct)
  - Qwen 3.5 (0.8B to 4B variants)
  - Qwen 2.5 (Abliterated/Uncensored models)
- **Real-time Performance:** fluid typing indicators and fast token generation.
- **Modern UI/UX:** Clean, intuitive interface inspired by top-tier chat applications.
- **Chat History Persistence:** Automatically saves your conversations for when you return, using local storage.
- **Resource Management:** View download speeds, progress, and easily delete models to free up space.

## 🛠️ Technology Stack

- **Frontend Framework:** [Flutter](https://flutter.dev/) / Dart Focus on a unified codebase for Android and cross-platform compilation.
- **State Management:** MultiProvider (Provider Pattern) + MVVM Architecture for robust data binding.
- **Local AI Inference:** Powered by [`llama_cpp_dart`](https://pub.dev/packages/llama_cpp_dart) for high-performance GGUF model execution.
- **Local Storage:** [`shared_preferences`](https://pub.dev/packages/shared_preferences) for quick app settings and chat persistence.
- **Network (for Downloads):** [`dio`](https://pub.dev/packages/dio) for reliable, resumable file downloading of large LLM files.
- **File System:** [`path_provider`](https://pub.dev/packages/path_provider) for managing downloaded models securely on the device.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.x or higher)
- Android Studio / Xcode for emulators or physical device testing
- Recommended Device: A modern smartphone with at least 4GB of RAM (6GB-8GB recommended for larger models).

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/1haris2/local_chat_ai.git
    cd local_chat_ai
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```
    _Note: For the best inference performance, always test on a physical release build rather than an emulator in debug mode._

### Building for Production (APK)

To generate a highly optimized and shrunk release Android APK:

```bash
flutter build apk --release
```

## 📱 Screenshots & Previews

_(Feel free to add screenshots of your App's Model Selector, Chat Interface, and Settings here!)_

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check out the [issues page](https://github.com/1haris2/local_chat_ai/issues).

## 📄 License

This project is open-source and available under the MIT License.

---

\*Developed with ❤️ by **Haris\***

offline chat ai

> > > > > > > 1f5df5f1cc645ca542e3927b2a7ad53d78c4870d
