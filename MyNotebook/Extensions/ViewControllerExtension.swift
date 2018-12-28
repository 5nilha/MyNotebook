//
//  ViewControllerExtension.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/28/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

extension UIViewController {
    
    func errorAlert(title: String, message: String) {
        
        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Ok") {
            alertView.dismiss(animated: true, completion: nil)
        }
        alertView.showError(title, subTitle: message)
    }
    
    
    
}
