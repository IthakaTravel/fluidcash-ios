//
//  WelcomeViewController.swift
//  FluidCash
//
//  Created by Aadesh Maheshwari on 21/11/15.
//  Copyright © 2015 Aadesh Maheshwari. All rights reserved.
//

import UIKit

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
                    
//                    let candidateFbDetails = Mapper().toJSONString(candidateFacebookData, prettyPrint: false)
//                    NSUserDefaultsUtils.setCandidateFacebookDetails(candidateFbDetails!)
//                    
//                    NSUserDefaultsUtils.setLoginSrc(LoginSrc.Facebook.rawValue)
//                    
//                    let authRequestBody = AuthRequestBody()
//                    authRequestBody.type = candidateFacebookData.type
//                    authRequestBody.token = candidateFacebookData.token
//                    authRequestBody.firstName = candidateFacebookData.firstName
//                    authRequestBody.lastName = candidateFacebookData.lastName
//                    authRequestBody.profilePic = candidateFacebookData.profilePic
//                    authRequestBody.id = candidateFacebookData.id
//                    authRequestBody.email = candidateFacebookData.email
//                    
//                    if let _: String = candidateFacebookData.gender {
//                        authRequestBody.gender = candidateFacebookData.gender
//                    }
//                    
//                    if let _: Int = candidateFacebookData.age {
//                        NSUserDefaultsUtils.setDoesNotHaveAge(false)
//                        authRequestBody.age = candidateFacebookData.age
//                    } else {
//                        NSUserDefaultsUtils.setDoesNotHaveAge(true)
//                    }
//                    
//                    self.authenticate(authRequestBody)
                    
                } else {
                    print(error)
                }
            })
        } else {
            print("Canceled the facebook login web page")
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
