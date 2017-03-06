//
//  AppDelegate.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setCustomFonts()
        
        return true
    }
    
    func setCustomFonts() {
        let fontName = "Futura"
        if let font = UIFont(name: fontName, size: 20),
            let smallerFont = UIFont(name: fontName, size: 16) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: smallerFont], for: .normal)
        }
    }

}
