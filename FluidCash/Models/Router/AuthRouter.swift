//
//  AuthRouter.swift
//  candidate
//
//  Created by Aditya Vyas on 08/09/15.
//  Copyright (c) 2015 Super. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum AuthRouter: RouterProtocol {
    
    case AuthenticateRequest(AuthRequestBody)
    case SendLocation(LocationBody)

    var path: String {
        switch self {
            
            case .AuthenticateRequest:
                return "/users/login"
            
            case .SendLocation:
                return "/locations"
        }
    }
    
    var method: Alamofire.Method {
        switch self {
            case .AuthenticateRequest:
                return .POST
            case .SendLocation:
                return .POST
        }
    }
    
    var parameters: AnyObject? {
        switch self {
            
            default:
                return nil

        }
    }
    
    var body: RequestBody? {
        switch self {
            
            case .AuthenticateRequest(let candidateFacebookData):
                return candidateFacebookData
            
            case .SendLocation(let cordinatesData):
                return cordinatesData
        }
    }
}
