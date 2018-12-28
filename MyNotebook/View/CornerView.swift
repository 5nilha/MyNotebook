//
//  CornerView.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/28/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import Foundation
import UIKit

class CornerView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOpacity = 0.7
//        layer.shadowRadius = 10.0
//        layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        layer.cornerRadius = 18.0
    }
    
}
