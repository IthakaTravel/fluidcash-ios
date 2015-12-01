//
//  NSUserDefaultsUtils.swift
//  candidate
//
//  Created by Aditya Vyas on 09/09/15.
//  Copyright (c) 2015 Super. All rights reserved.
//

import Foundation

struct NSUserDefaultsUtils {
    
    static let userAuthToken = "userAuthToken"
    
    static let userAnonymousToken = "userAnonymousToken"
    
    static let candidateDetails = "candidateDetails"
    
    static let loginSrc = "loginSrc"
    
    static let detailsFromFacebook = "detailsFromFacebook"
    
    // Candidate token
    static func setUserAuthToken(value: String) {
        setObject(value, key: userAuthToken)
    }
    
    static func getUserAuthToken() -> AnyObject? {
        return getObject(userAuthToken)
    }

    // Candidate anonymous token
    static func setUserAnonymousToken(value: String) {
        setObject(value, key: userAnonymousToken)
    }
    
    static func getUserAnonymousToken() -> AnyObject? {
        return getObject(userAnonymousToken)
    }
    
    // Candidate Details
    static func setCandidateDetails(value: String) {
        setObject(value, key: candidateDetails)
    }
    
    static func getCandidateDetails() -> AnyObject? {
        return getObject(candidateDetails)
    }
    
    // Candidate login src
    static func setLoginSrc(value: String) {
        setObject(value, key: loginSrc)
    }
    
    static func getLoginSrc() -> AnyObject? {
        return getObject(loginSrc)
    }

    // Candidate Facebook Details
    static func setCandidateFacebookDetails(value: String) {
        setObject(value, key: detailsFromFacebook)
    }
    
    static func getCandidateFacebookDetails() -> AnyObject? {
        return getObject(detailsFromFacebook)
    }
    
    /**
    Set boolean value in nsuser defaults
    
    :param: value Bool value to be stored
    :param: key   String identifier
    */
    static func setBool(value: Bool, key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(value, forKey: key)
    }
 
    /**
    Get boolean value for a key
    
    :param: key String identifier
    
    :returns: Bool
    */
    static func getBool(key: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(key)
    }
    
    /**
    Set object value in nsuser defaults
    
    :param: value AnyObject value to be stored
    :param: key   String identifier
    */
    static func setObject(value: AnyObject, key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
    }

    /**
    Get AnyObject value for a key
    
    :param: key String identifier
    
    :returns: AnyObject
    */
    static func getObject(key: String) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(key)
    }
    
    /**
    Set integer value in nsuser defaults
    
    :param: value Int value to be stored
    :param: key   String identifier
    */
    static func setInt(value: Int, key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(value, forKey: key)
    }
    
    /**
    Get Int value for a key
    
    :param: key String identifier
    
    :returns: Int
    */
    static func getInt(key: String) -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(key)
    }
    
    static func removeObjectForKey(key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(key)
    }
    
    static func deleteCandidate() {
        self.removeObjectForKey(userAuthToken)
        self.removeObjectForKey(userAnonymousToken)
        self.removeObjectForKey(candidateDetails)
        self.removeObjectForKey(loginSrc)
        self.removeObjectForKey(detailsFromFacebook)
    }
}