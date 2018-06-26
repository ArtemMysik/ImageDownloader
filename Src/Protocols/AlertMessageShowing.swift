//
//  AlertMessageShowing.swift
//  WordsCount
//
//  Created by   Artem on 25.06.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation
import UIKit

protocol AlertMessageShowing: class {
    func showAlert(message: String, handler: ((UIAlertAction) -> Void)?)
}

extension AlertMessageShowing where Self: UIViewController {
    
    func showAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        if self.isViewLoaded && (self.view.window != nil) {
            let alert = UIAlertController(title: nil,
                                          message: message,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: TextConstants.Alert.okAction,
                                          style: UIAlertActionStyle.default,
                                          handler: handler))
            
            if self.presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
