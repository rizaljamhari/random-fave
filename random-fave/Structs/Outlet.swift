//
//  Outlet.swift
//  random-fave
//
//  Created by Nurhasrizal Jamhari on 23/11/2021.
//  Copyright © 2021 rizaljamhari. All rights reserved.
//

import Foundation

struct Outlet: Decodable {
    let id: Int?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let share_url_details: ShareDetails?
    let company: Company?
}

struct ShareDetails: Decodable {
    let url: String
}
