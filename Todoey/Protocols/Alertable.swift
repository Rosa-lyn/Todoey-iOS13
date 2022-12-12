//
//  Alertable.swift
//  Todoey
//
//  Created by Rosalyn Land on 12/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit

protocol Alertable { }

extension Alertable where Self: UIViewController {

    func presentAddActionAlert(called title: String, placeholder: String, completion: @escaping (String) -> ()) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        alertController.addTextField() { textField in
            textField.placeholder = placeholder
        }

        let action = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            if let inputText = alertController?.textFields?.first?.text {
                completion(inputText)
            }
        }
        alertController.addAction(action)

        present(alertController, animated: true)

    }
}
