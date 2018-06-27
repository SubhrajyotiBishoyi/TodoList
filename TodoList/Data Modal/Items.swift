//
//  Items.swift
//  TodoList
//
//  Created by Satyabrat on 23/06/18.
//  Copyright © 2018 Subhrajyoti. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var createdDate : Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
