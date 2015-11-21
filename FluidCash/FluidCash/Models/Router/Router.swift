//
//  Router.swift
//  candidate
//
//  Created by Aditya Vyas on 08/07/15.
//  Copyright (c) 2015 Super. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

/**
*  Base router which has list of all the router that will be used to make network call
*  throughout the app.
*/
enum Router: URLRequestConvertible {
    
    // Custom variable defined in build.
//    static let baseURLString = NSBundle.mainBundle().objectForInfoDictionaryKey("API_BASE_URL")! as! String
    static let baseURLString = "http://192.168.2.172:3000"
    static let googlePlacesBaseURLString = "https://maps.googleapis.com/maps/api/place"
    case AuthRouteManager(AuthRouter)
    
    var URLRequest: NSMutableURLRequest {
        
        switch self {
            
            case .AuthRouteManager(let request):
            
                let urlRequest = configureRequest(request)
                return urlRequest
        }
    }
    
    /**
    Configure app level request object.
    - Set request path
    - Set request method
    - Set Headers [Authorization, Accept, Content-Type]
    - Set request body
    - set request parameters
    
    :param: requestObj Router of type RouterProtocol
    
    :returns: NSMutableURLRequest object
    */
    func configureRequest(requestObj: RouterProtocol) -> NSMutableURLRequest {
        
        let url = NSURL(string: Router.baseURLString)!
        
        let mutableURLRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(requestObj.path)) // Set request path
        mutableURLRequest.HTTPMethod = requestObj.method.rawValue // Set request method
        
        if let token: AnyObject = NSUserDefaultsUtils.getUserAuthToken() {
            // Auth token exists -> User is loggedin
//            print("loggedin")
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        } else if let anonymousToken: AnyObject = NSUserDefaultsUtils.getUserAnonymousToken() {
            // No auth token but anonymous token exists -> User is not loggedin & has anonymous token
            print("not loggedin")            
            mutableURLRequest.setValue("Bearer \(anonymousToken)", forHTTPHeaderField: "Authorization")
        }
        
        mutableURLRequest.setValue("application/vnd.getsuperapp.com+json; version=1.0;", forHTTPHeaderField: "Accept") // Set request version
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set content type
        
        if requestObj.method == Alamofire.Method.POST || requestObj.method == Alamofire.Method.PUT {
            // Request type is post/put -> check for request body
            if let body: RequestBody = requestObj.body {
                mutableURLRequest.HTTPBody = Mapper().toJSONString(body, prettyPrint: false)!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            }
        }
        
        // Check if request has parameters defined
        if let parameters: AnyObject = requestObj.parameters {
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters as? [String : AnyObject]).0
        } else {
            return mutableURLRequest
        }
    }
    
    
    func configureGooglePlacesRequest(requestObject: RouterProtocol) -> NSMutableURLRequest{
        
        let url = NSURL(string: requestObject.path)!
        
        let mutableUrlRequest = NSMutableURLRequest(URL: url)
        print(mutableUrlRequest.URLString)
        mutableUrlRequest.HTTPMethod = requestObject.method.rawValue
        mutableUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set content types
        return mutableUrlRequest
    }
}



// MARK: - Alamofire request extension
//  - Add debugLog method which logs request
extension Request {
    public func debugLog() -> Self {
        
        print("===============")
        print(self)
        print("Headers ---> ")
        print(self.request!.allHTTPHeaderFields)
        print("Body ---> ")
        if let requestBody = self.request!.HTTPBody {
            print(NSString(data: requestBody, encoding: NSUTF8StringEncoding))
        }
        print("===============")
        
        return self
    }
}