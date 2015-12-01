//
//  RouterProtocol.swift
//  candidate
//
//  Created by Aditya Vyas on 12/09/15.
//  Copyright (c) 2015 Super. All rights reserved.
//

import Foundation
import Alamofire

protocol RouterProtocol {
    
    var path: String { get }
    
    var method: Alamofire.Method { get }
    
    var parameters: AnyObject? { get }
    
    var body: RequestBody? { get }
}