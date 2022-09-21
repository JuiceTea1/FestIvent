//
//  AppDelegate.swift
//  FestIvent
//
//  Created by mac on 21.09.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    /*
    func firstAdd() {
        guard UserDefaults.standard.bool(forKey: "Not a first launch") == false else {
            return
        }
        UserDefaults.standard.set(true, forKey: "Not a first launch")

        self.coreDataManager.saveContext { error in
            guard error == nil else {
                return
            }
        }
    }
*/
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

