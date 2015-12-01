//
//  RequestBody.swift
//  candidate
//
//  Created by Aditya Vyas on 09/09/15.
//  Copyright (c) 2015 Super. All rights reserved.
//

import Foundation
import ObjectMapper

class RequestBody: NSObject, RequestBodyProtocol {
    
    required init?(_ map: Map) {
        
    }
    
    override init() {
        
    }
    
    func mapping(map: Map) {
    }
    
}