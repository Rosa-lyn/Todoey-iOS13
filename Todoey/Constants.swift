//
//  Constants.swift
//  Todoey
//
//  Created by Rosalyn Land on 12/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct K {

    static let addActionButton = "Add"
    
    struct Items {
        static let cellIdentifier = "TodoItemCell"
       
        static let alertTitle = "Add Item"
        static let alertTextFieldPlaceholder = "What do you need to do?"
    }

    struct Categories {
        static let cellIdentifier = "CategoryCell"
        static let itemsSegue = "goToItems"

        static let alertTitle = "Add Category"
        static let alertTextFieldPlaceholder = "Create a new category"
    }

    struct Errors {
        static let savingContext = "Error saving context: "
        static let fetchingFromContext = "Error fetching data from context: "
    }

}
