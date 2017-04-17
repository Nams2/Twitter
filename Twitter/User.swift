//
//  User.swift
//  Twitter
//
//  Created by Namrata Mehta on 4/14/17.
//  Copyright © 2017 Namrata Mehta. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: URL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    
    static let currentUserDataKey = "currentUserData"
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String as NSString?
        screenname = dictionary["screen_name"] as? String as NSString?
        
        //let profileUrlString = dictionary["profile_url"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String as NSString?

    }
    
    
    static var _currentUser: User?
    
    
    class var currentUser: User? {
        get{
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: currentUserDataKey) as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options:[]) // as! NSDictionary
                    _currentUser = User.init(dictionary: dictionary as! NSDictionary)
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: currentUserDataKey)
            }
            else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }

}
