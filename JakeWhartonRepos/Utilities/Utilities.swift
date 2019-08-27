
import Foundation
import UIKit
import EFInternetIndicator
import SystemConfiguration
import MBProgressHUD

public class  Utilities {
    
    private init() {}
    static let shared = Utilities()
    
    //----------------------------------------------------------------------
    //MARK:- Check Internet
    /// Check if there are internet or not
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
   
    //----------------------------------------------------------------------
    
    //MARK:- Validate date and time
    func calculateDateStrToComponent(date : String) -> String {
        
        let dateFormatter = DateFormatter()
        //2015-12-17T17:54:50Z"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" //"yyyy-MM-dd HH:mm:ss"
        
        let dateA = dateFormatter.date(from: date)
        let diffInYears = Calendar.current.dateComponents([.year], from: dateA!, to: Date()).year
        let diffInMonths = Calendar.current.dateComponents([.month], from: dateA!, to: Date()).month
        let diffInDays = Calendar.current.dateComponents([.day], from: dateA!, to: Date()).day
        let diffInHours = Calendar.current.dateComponents([.hour], from: dateA!, to: Date()).hour
        let diffInMins = Calendar.current.dateComponents([.minute], from: dateA!, to: Date()).minute
        let diffInSecds = Calendar.current.dateComponents([.second], from: dateA!, to: Date()).second
        
        var Strin :String = ""
        
        if (Int(diffInYears!) >= 1){ // print years
            Strin = "\(diffInYears!)" +  " " + "years ago"
        }else{
            if (Int(diffInMonths!) >= 1){ // print monthes
                Strin = "\(diffInMonths!)" + " " + "months ago"
            }else{
                if (Int(diffInDays!) >= 1){ // print days
                    Strin = "\(diffInDays!)" + " " + "days ago"
                }else{
                    if (Int(diffInHours!) >= 1){ // print hours
                        Strin = "\(diffInHours!)" +   " " + "hours ago"
                    }else{
                        if (Int(diffInMins!) >= 1){ // print Minutes
                            Strin = "\(diffInMins!)" +  " " + "minute ago"
                        }else{
                            Strin = "\(diffInSecds!)" +  " " + "seconds ago"
                        }
                        
                    }
                }
            }
        }
        
        return "\(String(describing: Strin))"
    }
    
    
    //----------------------------------------------------------------------
    //MARK:- Show Alert
    ///
    
    func showAlert(vc:UIViewController,title: String = "",message:String,acionString:String,completion:(()->Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: acionString, style: .default, handler: { (action) in
            completion?()
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    //----------------------------------------------------------------------
    
    //MARK:- openBasicAlert
    func showAlertMessage(title: String, Message msg: String,handler:(()->())? = nil) {
        var appdelegate : AppDelegate!
        if appdelegate == nil {
            appdelegate =  UIApplication.shared.delegate as? AppDelegate
        }
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            handler?()
        }
        alertController.addAction(cancelAction)
        appdelegate.window?.topMostWindowController()?.present(alertController, animated: true, completion: nil)
    }
    
}
