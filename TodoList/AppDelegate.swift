//
//  AppDelegate.swift
//  TodoList
//
//  Created by Satyabrat on 30/05/18.
//  Copyright © 2018 Subhrajyoti. All rights reserved.
//

import UIKit
import  RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
            } catch {
                print("Error in installing RealmSwift pods\(error)")
            }
        
        // Override point for customization after application launch.
        return true
    }

}

