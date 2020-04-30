import UIKit
import Flutter
import MobileCoreServices
import Photos
import Toast_Swift

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        guard call.method == "getBatteryLevel" else {
          result(FlutterMethodNotImplemented)
          return
        }
    let args = call.arguments as? [String:Any]
       
  
        let path : String = args?["path"] as! String
        let delay:Int = args?["delay"] as! Int
        self.receiveBatteryLevel(result: result,path: path ,delay: delay)
  
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }



        @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {

           var showMessage = ""

           if error != nil{

              showMessage = "保存失败"

           }else{

              showMessage = "保存成功"

           }

   print("encode result: \(showMessage)")

           

     

        }
 func getAllFilePath(_ dirPath: String) -> [String]? {
     var filePaths = [String]()
     
     do {
         let array = try FileManager.default.contentsOfDirectory(atPath: dirPath)
         
         for fileName in array {
             var isDir: ObjCBool = true
             
             let fullPath = "\(dirPath)/\(fileName)"
             
             if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                 if !isDir.boolValue {
                     filePaths.append(fullPath)
                 }
             }
         }
         
     } catch let error as NSError {
         print("get file path error: \(error)")
     }
     
     return filePaths;
 }


    private func receiveBatteryLevel(result: FlutterResult,path:String,delay:Int) {
//      let secondVC = UIStoryboard(name: "Spotlight", bundle: nil).instantiateViewController(withIdentifier: "spotlight") as UIViewController
//      self.window.rootViewController?.present(secondVC, animated: true, completion: nil)
         let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let gifPath =  docs[0] as String + "/"+String(Int(Date.init().timeIntervalSince1970)) + ".gif"
let paths = getAllFilePath(path)
        let imageArray: NSMutableArray = NSMutableArray()
        for i in paths! {
            print(i)
                   let image = UIImage.init(named: i)
                   if image != nil {
                       imageArray.add(image!)
                  
                   }
            
               }
       let ok = saveGifToDocument(imageArray: imageArray, gifPath,delay: delay)
        if(ok){
            PHPhotoLibrary.shared().performChanges ({
              let url = URL(fileURLWithPath: gifPath)
              PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
            }) { saved, error in
              if saved {
//             let alertController = UIAlertController(title: "encode success", message: nil, preferredStyle: UIAlertController.Style.alert)

                DispatchQueue.main.async {
  
                  
                    UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Encode success")
                 }
                print("Your image was successfully saved")
              }
            }
   
        }
        result(Int(1))
    }
 
    func saveGifToDocument(imageArray images: NSArray, _ gifPath: String,delay:Int) -> Bool {
        guard images.count > 0 &&
             gifPath.utf8CString.count > 0 else {
            return false
        }
      
        let url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, gifPath as CFString, .cfurlposixPathStyle, false)
        let destion = CGImageDestinationCreateWithURL(url!, kUTTypeGIF, images.count, nil)
        let adelay = Float(delay)/Float(100)
  print("delay time\(adelay)")
        let delayTime = [kCGImagePropertyGIFUnclampedDelayTime as String:adelay]
        let destDic   = [kCGImagePropertyGIFDictionary as String:delayTime]

//        let propertiesDic: NSMutableDictionary = NSMutableDictionary()
//        propertiesDic.setValue(kCGImagePropertyColorModelRGB, forKey: kCGImagePropertyColorModel as String)
//        propertiesDic.setValue(16, forKey: kCGImagePropertyDepth as String)
//        propertiesDic.setValue(1, forKey: kCGImagePropertyGIFLoopCount as String)
//
//        let gitDestDic = [kCGImagePropertyGIFDictionary as String:propertiesDic]
//        CGImageDestinationSetProperties(destion!, gitDestDic as CFDictionary?)
        for image in images {
            CGImageDestinationAddImage(destion!, (image as! UIImage).cgImage!, destDic as CFDictionary)
            print("kkkkkkkk\(images.count)")
        }
     return CGImageDestinationFinalize(destion!)

     

  
    }
}
