//
//  City.swift
//  random-fave
//
//  Created by Nurhasrizal Jamhari on 23/11/2021.
//  Copyright © 2021 rizaljamhari. All rights reserved.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let country: String
    let country_code: String
    let currency: String
}
