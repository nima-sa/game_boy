import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)


            
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let importedURL = FlutterMethodChannel(name: "haptic", binaryMessenger: controller.binaryMessenger)
    importedURL.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "impact_i1" {
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator().impactOccurred(intensity: 1)
            } else if #available(iOS 10.0, *){
                UIImpactFeedbackGenerator().impactOccurred()
            }
        } else if call.method == "success" {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else if call.method == "error" {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        result(true)
        
    })



    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
