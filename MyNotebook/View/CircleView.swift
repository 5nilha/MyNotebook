//
//  CircleView.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/25/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        layer.shadowRadius = 0.4
        
    }
}
