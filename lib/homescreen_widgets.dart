library homescreen_widgets;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomescreenWidgets {
  static const MethodChannel _channel =
      const MethodChannel('dev.jackmoseley.homescreen_widgets');

  /// Updates all widgets specified for each platform.
  ///
  /// Android requires the class name for the App Widget to be specified (e.g MyAppWidgetClass)
  ///
  /// iOS you can either specify the 'kind' assigned for your widget, or specify 'all' (default) if you want to reload every widget for your application
  static Future<void> updateWidgets({String? android, String? iOS = 'all'}) {
    if (Platform.isAndroid && android != null) {
      return _channel.invokeMethod('update_widget', {'className': android});
    } else if (Platform.isIOS && iOS != null) {
      return _channel.invokeMethod('update_widget', {'kind': iOS});
    }
    return Future.value();
  }

  static Future<void> setData({
    required dynamic data,
    required String key,
    String? appGroup,
  }) async {
    assert(
      data is List<dynamic> || data is Map<String, dynamic> || data is String,
    );

    String encodedData;
    if (data is Map<String, dynamic> || data is List<dynamic>) {
      encodedData = jsonEncode(data);
    } else if (data is String) {
      encodedData = data;
    } else {
      throw TypeError();
    }

    if (Platform.isIOS && appGroup != null) {
      return _channel.invokeMethod(
        'set_item',
        {'group': appGroup, 'data': encodedData, 'key': key},
      );
    } else if (Platform.isAndroid) {
      final preferences = await SharedPreferences.getInstance();
      preferences.setString(key, encodedData);
    }
  }

  static Future<void> removeItem({
    required String key,
    String? appGroup,
  }) async {
    if (Platform.isIOS && appGroup != null) {
      return _channel.invokeMethod(
        'set_item',
        {'group': appGroup, 'key': key},
      );
    } else if (Platform.isAndroid) {
      final preferences = await SharedPreferences.getInstance();
      preferences.remove(key);
    }
  }
}
