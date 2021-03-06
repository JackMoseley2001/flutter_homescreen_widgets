import Flutter
import UIKit
import WidgetKit

public class SwiftHomescreenWidgetsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "homescreen_widgets", binaryMessenger: registrar.messenger())
    let instance = SwiftHomescreenWidgetsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "update_widget":
        updateWidget(call: call, result: result)
        break
      case "set_item":
        setUserDefaultItem(call: call, result: result)
        break
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  private func updateWidget(call: FlutterMethodCall, result: @escaping FlutterResult) {
    if let arguments = call.arguments as? [String: Any] {
      if let widgetKind = arguments["kind"] as? String {
        if #available(iOS 14, *) {
          if (widgetKind == "all") {
            WidgetCenter.shared.reloadAllTimelines()
            return result(true)
          } else {
            WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
            return result(true)
          }
        }
      }
    }
    return result(FlutterError(code: "-1", message: "Provided arguments invalid", details: nil))
  }

  private func setUserDefaultItem(call: FlutterMethodCall, result: @escaping FlutterResult) {
    if let arguments = call.arguments as? [String: Any] {
      if let appGroup = arguments["group"] as? String,
         let data = arguments["data"] as? String,
         let key = arguments["key"] as? String {
        if let defaults = UserDefaults.init(suiteName: appGroup) {
          defaults.set(data, forKey: key)
          return result(true)
        } else {
          return result(FlutterError(code: "-2", message: "Failed to create shared user defaults", details: nil))
        }
      }
    }

    return result(FlutterError(code: "-1", message: "Provided arguments invalid", details: nil))
  }

}
