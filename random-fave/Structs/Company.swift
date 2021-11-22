//
//  Company.swift
//  random-fave
//
//  Created by Nurhasrizal Jamhari on 23/11/2021.
//  Copyright © 2021 rizaljamhari. All rights reserved.
//

import Foundation

struct Company: Decodable {
    let id: Int
    let name: String
    let logo: String?
    let description: String?
    let rating: Double?
}
