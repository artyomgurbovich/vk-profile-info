//
//  ViewController.swift
//  VKProfileInfo
//
//  Created by Artyom Gurbovich on 1/27/20.
//  Copyright © 2020 Artyom Gurbovich. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class LoginViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    let clientID = -1
    var authLink = ""
    var accessToken = ""
    var email = ""
    var profileInfo = JSON()
    var photo = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        webView.navigationDelegate = self
        authLink = "https://oauth.vk.com/authorize?client_id=\(clientID)&" +
                           "redirect_uri=https://oauth.vk.com/blank.html&" +
                                                    "response_type=token&" +
                                                            "scope=email&" +
                                                                "lang=en&" +
                                                                 "v=5.103"
        webView.load(URLRequest(url: URL(string: authLink)!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.isHidden = false
        webView.load(URLRequest(url: URL(string: authLink)!))
    }
    
    func getAccessTokenAndEmail(from activeURL: String) -> Bool {
        if activeURL.contains("access_token") {
            let items = activeURL.split(separator: "&")
            accessToken = String(items.filter{$0.contains("access_token")}[0].split(separator: "=")[1])
            email = String(items.filter{$0.contains("email")}[0].split(separator: "=")[1])
            return true
        }
        return false
    }
    
    func getProfileInfo(completion: (() -> Void)?) {
        let parameters: Parameters = ["access_token": accessToken, "v": "5.103", "lang": "en", "fields": "photo_max_orig, education, counters,                                     screen_name, bdate, city, country, relation, contacts, personal"]
        request("https://api.vk.com/method/users.get", method: .get, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.profileInfo = JSON(value)["response"][0]
                self.downloadPhoto(completion: {
                    completion?()
                })
            }
        }
    }
    
    func downloadPhoto(completion: (() -> Void)?) {
        request(profileInfo["photo_max_orig"].stringValue, method: .get).responseImage(completionHandler: { response in
            if let data = response.result.value {
                self.photo = data
                completion?()
            }
        })
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let activeURL = webView.url?.absoluteString {
            if getAccessTokenAndEmail(from: activeURL) {
                webView.isHidden = true
                getProfileInfo(completion: {
                    self.performSegue(withIdentifier: "ProfileInfo", sender: nil)
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileInfoViewController = segue.destination as? ProfileInfoViewController {
            profileInfoViewController.photo = photo
            profileInfoViewController.firstName = profileInfo["first_name"].string ?? "―"
            profileInfoViewController.lastName = profileInfo["last_name"].string ?? "―"
            profileInfoViewController.screenName = "@" + profileInfo["screen_name"].stringValue
            profileInfoViewController.friends = profileInfo["counters"]["friends"].int ?? 0
            profileInfoViewController.followers = profileInfo["counters"]["followers"].int ?? 0
            profileInfoViewController.birthday = profileInfo["bdate"].string ?? "―"
            profileInfoViewController.country = profileInfo["country"]["title"].string ?? "―"
            profileInfoViewController.city = profileInfo["city"]["title"].string ?? "―"
            profileInfoViewController.relationship = profileInfo["relation"].int ?? 0
            profileInfoViewController.email = email
            profileInfoViewController.mobile = profileInfo["mobile_phone"].string ?? "―"
            profileInfoViewController.languages = profileInfo["personal"]["langs"].arrayValue.map{$0.stringValue}.joined(separator: ", ")
            profileInfoViewController.education = profileInfo["university_name"].string ?? "―"
            profileInfoViewController.viewsOnSmoking = profileInfo["personal"]["smoking"].int ?? 0
            profileInfoViewController.viewsOnAlcohol = profileInfo["personal"]["alcohol"].int ?? 0
        }
    }
}
