//
//  extension.swift
//  fitnessApp
//
//  Created by oguzhangumus on 20.05.2024.
//

import UIKit

class AlertHelper {
    static let shared = AlertHelper() // Singleton instance
    
    private init() {} // Prevent external initialization
    
    func showAlert(from viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

