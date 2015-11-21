//
//  DataGatheringViewController.swift
//  FluidCash
//
//  Created by Aadesh Maheshwari on 21/11/15.
//  Copyright © 2015 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage
import CoreLocation
import Alamofire
import SwiftyJSON

class LocationBody: RequestBody {
    var latitude: Float = 0
    var longitude: Float = 0
    var accuracyInMeters: Int = 10
    
    class func newInstance(map: Map) -> Mappable? {
        return AuthRequestBody()
    }
    
    override func mapping(map: Map) {
        latitude   <- map["latitude"]
        longitude   <- map["longitude"]
        accuracyInMeters   <- map["accuracy"]
    }
}

class DataGatheringViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var makeMagicButton: UIButton!
    @IBOutlet weak var amountTestField: UITextField!
    let locationManager = CLLocationManager()
    var currentUserLocation: CLLocation?
    var locationUpdatedToServer: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Exhange details"
        makeMagicButton.layer.cornerRadius = 5
        makeMagicButton.layer.masksToBounds = true
        
        //get the profile pic URL

        if let candidateFbDetails: AnyObject = NSUserDefaultsUtils.getCandidateFacebookDetails() {
            let strCandidateFbDetails: String = (candidateFbDetails as? String)!
            
            let candidateFbDetailsObj: CandidateFacebookData = Mapper<CandidateFacebookData>().map(strCandidateFbDetails)!
            if let profilePic = candidateFbDetailsObj.profilePicURL {
                let profileView = UIImageView(frame: CGRectMake(0, 0, 44, 44))
                profileView.sd_setImageWithURL(NSURL(string: profilePic))
                profileView.layer.cornerRadius = 22
                profileView.layer.masksToBounds = true
                let barButtonItem = UIBarButtonItem(customView: profileView)
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
        self.navigationItem.hidesBackButton = true
        
        //request for the location
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentUserLocation = manager.location
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if !self.locationUpdatedToServer {
            let locationBody = LocationBody()
            locationBody.latitude = Float(locValue.latitude)
            locationBody.longitude = Float(locValue.longitude)
            sendLocation(locationBody)
        }
    }
    
    func sendLocation(reqBody: LocationBody) {
        
        //send logged in data to server
        Alamofire.request(Router.AuthRouteManager(AuthRouter.SendLocation(reqBody)))
            .debugLog()
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    print("response \(json)")
                    self.locationUpdatedToServer = true
                } else {
                    // On auth fail, send back to login screen asking user to relogin.
                    print("Error \(response.response?.statusCode) message \(response.response?.debugDescription) ")
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.amountTestField.resignFirstResponder()
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
