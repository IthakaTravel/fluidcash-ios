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

class DataGatheringViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var makeMagicButton: UIButton!
    @IBOutlet weak var amountTestField: UITextField!
    let locationManager = CLLocationManager()
    var currentUserLocation: CLLocation?
    
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
