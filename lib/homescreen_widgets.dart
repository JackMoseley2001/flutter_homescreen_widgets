import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class HomescreenWidgets {
  static const MethodChannel _channel =
      const MethodChannel('dev.jackmoseley.homescreen_widgets');

  static Future<bool> updateWidgets({String android}) {
    if (Platform.isAndroid && android != null) {
      return _channel.invokeMethod('update_widget', {'className': android});
    }
    return Future.value(false);
  }
}
