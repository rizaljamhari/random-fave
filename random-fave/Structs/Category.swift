//
//  Category.swift
//  random-fave
//
//  Created by Nurhasrizal Jamhari on 22/11/2021.
//  Copyright © 2021 rizaljamhari. All rights reserved.
//

import Foundation

//struct Categories<T: Decodable>: Decodable {
//    let results: [T]
//}

struct Category: Decodable {
    let id: Int
    let name: String
    let deeplink: String
    let app_icon: String
}
