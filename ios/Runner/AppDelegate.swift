import UIKit
import Flutter
// import Braintree

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
        // BTAppContextSwitcher.setReturnURLScheme("com.ezeematrix.kryptonia.payments")
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //     if url.scheme == "com.ezeematrix.kryptonia.payments" {
    //         return BTAppContextSwitcher.handleOpenURL(url)
    //     }
        
    //     return false
    // }

}