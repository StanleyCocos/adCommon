import 'package:screenshot_callback/screenshot_callback.dart';

class ScreenshotManager {
  static ScreenshotManager? _instance;

  factory ScreenshotManager() {
    if (_instance == null) _instance = ScreenshotManager._();
    return _instance!;
  }

  late ScreenshotCallback screenshotCallback;
  Function? callback;

  ScreenshotManager._() {
    screenshotCallback = ScreenshotCallback();
  }

  void init() {
    screenshotCallback.addListener(
      () {
        if (callback != null) callback!();
      },
    );
  }
}
