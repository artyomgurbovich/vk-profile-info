//
//  ProfileInfoViewController.swift
//  VKProfileInfo
//
//  Created by Artyom Gurbovich on 1/28/20.
//  Copyright © 2020 Artyom Gurbovich. All rights reserved.
//

import UIKit
import WebKit

class ProfileInfoViewController: UIViewController {
    
    var photo = UIImage()
    var firstName = ""
    var lastName = ""
    var screenName = ""
    var friends = 0
    var followers = 0
    var birthday = ""
    var country = ""
    var city = ""
    var relationship = 0
    var email = ""
    var mobile = ""
    var languages = ""
    var education = ""
    var viewsOnSmoking = 0
    var viewsOnAlcohol = 0
    
    let relationStatus = ["―", "Single", "In a relationship", "Engaged", "Married", "It's complicated", "Actively searching", "In love", "In a civil union"]
    let viewsStatus = ["―", "Very negative", "Negative", "Neutral", "Compromisable", "Positive"]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var viewsOnSmokingLabel: UILabel!
    @IBOutlet weak var viewsOnAlcoholLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        blurImageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.image = photo
        blurImageView.image = photo
        fullNameLabel.text = firstName + " " + lastName
        screenNameLabel.text = screenName
        friendsLabel.text = String(friends)
        followersLabel.text = String(followers)
        birthdayLabel.text = birthday
        countryLabel.text = country
        cityLabel.text = city
        relationshipLabel.text = relationStatus[relationship]
        emailLabel.text = email
        mobileLabel.text = !mobile.isEmpty ? mobile : "―"
        languagesLabel.text = languages
        educationLabel.text = education
        viewsOnSmokingLabel.text = viewsStatus[viewsOnSmoking]
        viewsOnAlcoholLabel.text = viewsStatus[viewsOnAlcohol]
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {
                self.dismiss(animated: true)
            })
        }
    }
}
