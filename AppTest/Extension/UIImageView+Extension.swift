//
//  UIImageView+Extension.swift
//  AppTest
//
//  Created by Ganesh Kumar on 15/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
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
