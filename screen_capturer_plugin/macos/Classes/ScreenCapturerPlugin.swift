import Cocoa
import FlutterMacOS

public class ScreenCapturerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "screen_capturer_plugin", binaryMessenger: registrar.messenger)
    let instance = ScreenCapturerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAccessAllowed":
      isAccessAllowed(call, result:result)
    case "requestAccess":
      requestAccess(call, result:result)
    case "makeScreenshot":
      makeScreenshot(call, flutterResult:result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func isAccessAllowed(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if #available(macOS 10.16, *) {
      result(CGPreflightScreenCaptureAccess())
      return
    };
    result(true)
  }

  public func requestAccess(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args:[String: Any] = call.arguments as! [String: Any]
    let onlyOpenPrefPane: Bool = args["onlyOpenPrefPane"] as! Bool

    if (!onlyOpenPrefPane) {
      if #available(macOS 10.16, *) {
        CGRequestScreenCaptureAccess()
      } else {
        // Fallback on earlier versions
      }
    } else {
      let prefpaneUrl = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!
      NSWorkspace.shared.open(prefpaneUrl)
    }
    result(true)
  }

  public func makeScreenshot(_ call: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
    var displayCount: UInt32 = 0;
    var displayCountResult = CGGetActiveDisplayList(0, nil, &displayCount)
    if (displayCountResult != CGError.success) {
      print("error: \(displayCountResult)")
      return
    }
    let allocated = Int(displayCount)
    let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
    displayCountResult = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)

    if (displayCountResult != CGError.success) {
      print("error: \(displayCountResult)")
      return
    }

    var resultList: [String] = []
    for i in 1...displayCount {

      let screenShot:CGImage = CGDisplayCreateImage(activeDisplays[Int(i-1)])!
      //                  let bitmapRep = NSBitmapImageRep(cgImage: screenShot)
      //                  let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
      resultList.append(screenShot.base64EncodedString)
    }
    flutterResult(resultList)
  }
}

extension CGImage {
  var jpegData: Data? {
    guard let mutableData = CFDataCreateMutable(nil, 0),
          let destination = CGImageDestinationCreateWithData(mutableData, kUTTypeJPEG, 1, nil)
    else {
      return nil
    }
    CGImageDestinationAddImage(destination, self, nil)
    guard CGImageDestinationFinalize(destination) else { return nil }
    return mutableData as Data
  }

  var base64EncodedString : String {
    return self.jpegData?.base64EncodedString() ?? ""
  }
}
