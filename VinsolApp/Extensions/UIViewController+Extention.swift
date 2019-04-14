//
//  UIViewController+Extention.swift
//  VinsolApp
//
//  Created by Sunita Moond on 13/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(alertTitle: String, alertMessage: String, actionTitle: String = "Ok", actionHandler: ((UIAlertAction) -> Void)? = nil, dismiss: Bool = false,  persistenceTime: Double = 0.7, exitAction: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default, handler: actionHandler)
        if dismiss {
            let when = DispatchTime.now() + persistenceTime
            DispatchQueue.main.asyncAfter(deadline: when){
                alertController.dismiss(animated: true, completion: nil)
            }
        } else {
            alertController.addAction(defaultAction)
        }
        if let exitAction = exitAction {
            alertController.addAction(exitAction)
        }


        present(alertController, animated: true, completion: nil)
    }
}


