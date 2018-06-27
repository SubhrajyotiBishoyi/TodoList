//
//  Category.swift
//  TodoList
//
//  Created by Satyabrat on 23/06/18.
//  Copyright © 2018 Subhrajyoti. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Items>()
}
