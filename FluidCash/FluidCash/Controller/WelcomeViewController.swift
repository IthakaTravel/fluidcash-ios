//
//  WelcomeViewController.swift
//  FluidCash
//
//  Created by Aadesh Maheshwari on 21/11/15.
//  Copyright © 2015 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SwiftyJSON

class AuthRequestBody: RequestBody {
    var token: String?
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var profilePic: String?
    var gender: String?
    var age: Int?
    
    class func newInstance(map: Map) -> Mappable? {
        return AuthRequestBody()
    }
    
    override func mapping(map: Map) {
        token       <- map["token"]
        id          <- map["id"]
        firstName   <- map["firstName"]
        lastName    <- map["lastName"]
        email       <- map["email"]
        profilePic  <- map["profilePic"]
        gender      <- map["gender"]
        age         <- map["age"]
    }
}

class WelcomeViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var singUpLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton: FBSDKLoginButton  = FBSDKLoginButton()
        loginButton.center = CGPointMake(self.view.center.x, self.singUpLabel.center.y + 47)
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.delegate = self
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("login done with completion reuslt \(result.token.description)")
        getFBUserData()
    }
    
    private func getFBUserData(){
        let params = ["fields": "id, name, first_name, last_name, picture.type(large), email, work, location, education, friends, birthday, gender"]
        
        if((FBSDKAccessToken.currentAccessToken()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: params).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error == nil) {
                    //print(result)
                    let candidateFacebookData = CandidateFacebookData()
                    candidateFacebookData.firstName = result.valueForKey("first_name") as? String
                    candidateFacebookData.lastName = result.valueForKey("last_name") as? String
                    candidateFacebookData.email = result.valueForKey("email") as? String
                    candidateFacebookData.id = result.valueForKey("id") as? String
                    candidateFacebookData.profilePicURL = result.valueForKeyPath("picture.data.url") as? String
                    candidateFacebookData.token = FBSDKAccessToken.currentAccessToken().tokenString
                    
                    let candidateFbDetails = Mapper().toJSONString(candidateFacebookData, prettyPrint: false)
                    print(" candidate FB details \(candidateFbDetails)")
                    NSUserDefaultsUtils.setCandidateFacebookDetails(candidateFbDetails!)
                
                    let authRequestBody = AuthRequestBody()
                    authRequestBody.token = candidateFacebookData.token
                    authRequestBody.firstName = candidateFacebookData.firstName
                    authRequestBody.lastName = candidateFacebookData.lastName
                    authRequestBody.profilePic = candidateFacebookData.profilePicURL
                    authRequestBody.id = candidateFacebookData.id
                    authRequestBody.email = candidateFacebookData.email
                    self.authenticate(authRequestBody)
                    
                } else {
                    print(error)
                }
            })
        } else {
            print("Canceled the facebook login web page")
        }
    }
    
    func authenticate(reqBody: AuthRequestBody) {
        
        //send logged in data to server
        Alamofire.request(Router.AuthRouteManager(AuthRouter.AuthenticateRequest(reqBody)))
            .debugLog()
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    
                    var json = JSON(response.result.value!)
                    print("response \(json)")
                    let authToken = json["token"].string
                    NSUserDefaultsUtils.setUserAuthToken(authToken!)
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let dataGatheringViewController = storyBoard.instantiateViewControllerWithIdentifier("DataGatheringViewController")
                    self.navigationController?.pushViewController(dataGatheringViewController, animated: true)
                    
                } else {
                    // On auth fail, send back to login screen asking user to relogin.
                    print("Error \(response.response?.statusCode) message \(response.response?.debugDescription) ")
                }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logout")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
