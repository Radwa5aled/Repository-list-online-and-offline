
//
import Foundation
import Alamofire


class JakeWhartonReposService: NSObject {
    
    //General func for api request with general return type to use it with all apis and different response model types
    func apiGenaric(parameters:[String:Any]! = nil, service:String,hTTPMethod:HTTPMethod,success:@escaping(_ model: [ReposModel])->(Void) , failure:@escaping (_ error :String, _ isFromServer: Bool)->(Void)){
        
        let headers = ["Content-Type":"application/json"]
        
        NetowrkHelper.networkRequester(domainUrl: nil, service: service,headers: headers, hTTPMethod: hTTPMethod, parameters: parameters, callbackNoInterent: {
            () in
            failure("No Internet Connection", false)
        })
        {
            (response) in
            if(response.result.isFailure)
            {
                print("❌ " + (response.result.error?.localizedDescription)! as Any);
                failure((response.result.error?.localizedDescription)!, true)
                
            }
            if(response.result.isSuccess)
            {
                if let JSON = response.result.value
                {
                    
                    print("✍️ JSON: \(JSON)")
                    
                    do {
                        let jsonDecoder = JSONDecoder()
                        let genaricModel = try jsonDecoder.decode([ReposModel].self, from: JSON.data(using: .utf8)!)
                        
                        // if let status = genaricModel.status ,status == 1 {
                        success(genaricModel)
                        //                        }else {
                        //
                        //                            print("❌ \(String(describing: genaricModel.message))")
                        //                            failure( genaricModel.message, true)
                        //                        }
                        
                    } catch let error { // mapping fail
                        print("❌ Error in Mapping \(service) in \(error)")
                        // failure( "Erroring in \(service)",true)
                    }
                    
                    
                }
            }else { // response fail
                print("❌ Response fail : \(response.result.description)")
                
            }
        }
        
        
        
    }
    
}
