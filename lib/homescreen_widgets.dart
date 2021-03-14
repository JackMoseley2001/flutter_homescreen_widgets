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
  /// iOS you can either specify the 'kind' assigned for your widget, or specify 'all' if you want to reload every widget for your application
  static Future<bool> updateWidgets({String? android, String? iOS}) {
    if (Platform.isAndroid && android != null) {
      return _channel.invokeMethod('update_widget', {'className': android})
          as Future<bool>;
    } else if (Platform.isIOS && iOS != null) {
      return _channel.invokeMethod('update_widget', {'kind': iOS})
          as Future<bool>;
    }
    return Future.value(false);
  }

  static Future<bool> setData({
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
      ) as FutureOr<bool>;
    } else if (Platform.isAndroid) {
      final preferences = await SharedPreferences.getInstance();
      preferences.setString(key, encodedData);
    }

    return Future.value(false);
  }
}
