//
//  UIColor+extension.swift
//  random-fave
//
//  Created by Nurhasrizal Jamhari on 23/11/2021.
//  Copyright © 2021 rizaljamhari. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var mainPink = UIColor(red: 222/255, green: 32/255, blue: 106/255, alpha: 1)
    static var favePink = UIColor(red: 251/255, green: 232/255, blue: 240/255, alpha: 1)
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
