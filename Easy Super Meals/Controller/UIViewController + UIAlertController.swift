//
//  UIViewController + UIAlertController.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 21/02/2021.
//

import UIKit

//MARK:-A UIViewController extension to hold a global showErrorAlert dialog

extension UIViewController  {

    
    //MARK:-showAlert Dialog
    /*
      show an alert message
     */
    
    func showAlertDialog(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
