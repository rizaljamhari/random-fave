//
//  UserDefaults+extension.swift
//  random-fave
//
//  Created by Nurhasrizal Jamhari on 22/11/2021.
//  Copyright © 2021 rizaljamhari. All rights reserved.
//

import Foundation

extension UserDefaults {

    func setUserLatitude(value: String) {
        set(value, forKey: "user.location.latitude")
    }
    
    func getUserLatitude()-> String {
        return string(forKey: "user.location.latitude") ?? ""
    }

    func setUserLongitude(value: String) {
        set(value, forKey: "user.location.longitude")
    }
    
    func getUserLongitude()-> String {
        return string(forKey: "user.location.longitude") ?? ""
    }
    
    func setUserCityId(value: Int) {
        set(value, forKey: "user.location.city_id")
    }
    
    func getUserCityId()-> Int {
        return integer(forKey: "user.location.city_id")
    }
    
    func setUserCountryCode(value: String) {
        set(value, forKey: "user.location.country_code")
    }
    
    func getUserContryCode() -> String {
        return string(forKey: "user.location.country_code") ?? ""
    }
}
