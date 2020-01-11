//
//  AppDelegate.swift
//  tenki-app
//
//  Created by 木村幸 on 2020/01/10.
//  Copyright © 2020 木村幸. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // PUSH要求する
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                
                if !granted {
                    let alert = UIAlertController(title: "通知がOFF", message: "プッシュ通知がOFF。PUSHは届かない", preferredStyle: .alert)
                    let cancelAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                        (action: UIAlertAction!) -> Void in
                        print("cancelAction")
                    })
                    alert.addAction(cancelAction)
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "通知ON", message: "プッシュ通知がON。PUSHが届く", preferredStyle: .alert)
                    let cancelAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler:{
                        (action: UIAlertAction!) -> Void in
                        print("cancelAction")
                    })
                    alert.addAction(cancelAction)
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            })
        UNUserNotificationCenter.current().delegate = self
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([ .badge, .sound, .alert ])
    }
}

