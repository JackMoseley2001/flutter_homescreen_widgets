package com.m4consulting.homescreen_widgets

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** HomescreenWidgetsPlugin */
class HomescreenWidgetsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dev.jackmoseley.homescreen_widgets")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "update_widget") {
      var className = call.argument<String>("className") ?: return result.error("-1", "No class name provided", IllegalArgumentException())
      var javaClass = Class.forName("${context.packageName}.${className}")

      var intent = Intent(context.applicationContext, javaClass)
      intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
      var manager = AppWidgetManager.getInstance(context.applicationContext)
      var componentName = ComponentName(context, javaClass)
      var ids = manager.getAppWidgetIds(componentName)

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
        manager.notifyAppWidgetViewDataChanged(ids, android.R.id.list)
      }

      intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
      context.sendBroadcast(intent)
      result.success(true)
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
