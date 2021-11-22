//
//  UIImageView+URL.swift
//  random-fave
//
//  Created by Nurhasrizal Jamhari on 22/11/2021.
//  Copyright © 2021 rizaljamhari. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
