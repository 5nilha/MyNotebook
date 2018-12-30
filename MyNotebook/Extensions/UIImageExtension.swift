//
//  UIImageExtension.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/29/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func UIImageToData(compressionRatio: CGFloat) -> Data? {
        return autoreleasepool(invoking: { () -> Data? in
            return self.jpegData(compressionQuality: compressionRatio)
        })
    }
    
    
}
