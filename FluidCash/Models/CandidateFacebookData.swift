//
//  CandidateFacebookData.swift
//  FluidCash
//
//  Created by Aadesh Maheshwari on 21/11/15.
//  Copyright © 2015 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper

class CandidateFacebookData: RequestBody {
    var firstName: String?
    var lastName: String?
    var email: String?
    var id: String?
    var profilePicURL: String?
    var token: String?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        token       <- map["token"]
        id          <- map["id"]
        firstName   <- map["firstName"]
        lastName    <- map["lastName"]
        email       <- map["email"]
        profilePicURL <- map["profilePic"]
    }

}
