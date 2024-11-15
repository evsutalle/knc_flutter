import Flutter
import UIKit
import GoogleMaps // Import Google Maps framework

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Provide the Google Maps API key here
    GMSServices.provideAPIKey("AIzaSyDgqckWe7uO0V7A4fkQg3rTstIr4GvXyLs")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
