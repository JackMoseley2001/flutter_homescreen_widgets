
import 'dart:async';

import 'package:flutter/services.dart';

class HomescreenWidgets {
  static const MethodChannel _channel =
      const MethodChannel('homescreen_widgets');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
