//
//  Fave.swift
//  random-fave
//
//  Created by Nurhasrizal Jamhari on 22/11/2021.
//  Copyright © 2021 rizaljamhari. All rights reserved.
//

import Foundation
import Moya

public enum Fave {
    case location
    case fragments
    case outlets(categoryId: Int)
}

extension Fave: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://api.myfave.com/api/fave")!
    }
    
    public var path: String {
        switch self {
        case .location:
            return "/v3/location"
        case .fragments:
            return "/v5/\(UserDefaults.standard.getUserContryCode())/explore/fragments"
        case .outlets(_):
            return "/v5/\(UserDefaults.standard.getUserContryCode())/outlets"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .location, .fragments, .outlets:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .location:
            return .requestParameters(parameters: [
                "latitude": UserDefaults.standard.getUserLatitude(),
                "longitude": UserDefaults.standard.getUserLongitude()
            ], encoding: URLEncoding.queryString)
        case .fragments:
            return .requestParameters(parameters: [
                "city_id": UserDefaults.standard.getUserCityId(),
            ], encoding: URLEncoding.queryString)
        case let .outlets(categoryId):
            return .requestParameters(parameters: [
                "city_id": UserDefaults.standard.getUserCityId(),
                "latitude": UserDefaults.standard.getUserLatitude(),
                "longitude": UserDefaults.standard.getUserLongitude(),
                "limit": 30,
                "page": Int.random(in: 1..<6),
                "opening_hours": "any",
                "sort_by": "nearby",
                "main_category_id": categoryId
            ], encoding: URLEncoding.queryString)
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
