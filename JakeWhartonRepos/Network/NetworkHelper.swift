

import Foundation
import Alamofire

class NetowrkHelper {
    //Core Function of network
    internal static func networkRequester(
        domainUrl: String?,
        service: String,
        headers: [String:String]? = nil,
        hTTPMethod: HTTPMethod,
        parameters: [String:Any]? = nil,
        callbackNoInterent: (() -> Void),
        callbackString: @escaping ((DataResponse<String>) -> Void))
        
    {
        
        if Utilities.shared.isConnectedToNetwork() == true {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
           
            let UrlString = (domainUrl == nil ? Constants.coreURL : domainUrl!)+service
            
            print("✍🏻 Request URL >>>> " + UrlString)
            
            if let parameters = parameters {
                print("✍🏻 Request Body >>>> " + String(describing: parameters))
            }
            Alamofire.request(UrlString, method: hTTPMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .failure(let error):
                    print("❌ Respons Error >>>> " + error.localizedDescription)
                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                        print("❌ Respons Error Details >>>> " + responseString)
                        failGetData()
                        callbackString(response)
                    }
                case .success(let responseObject):
                    print("✅ Respons Object >>>> " + responseObject)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    callbackString(response)
                }
            }
        } else {
            print("⁉️ No Internet Conection!")
            //            failGetData()
            callbackNoInterent()
        }
    }
    
    
    static func failGetData() -> Void {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        Utilities.shared.showAlertMessage(title: "Request Failure", Message: "Please make sure of the following :\n  1-You have good net connection. \n 2-Server Error.\n Or try again later")
    }
    
}

