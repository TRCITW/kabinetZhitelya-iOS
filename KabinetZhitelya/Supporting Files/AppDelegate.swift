//
//  AppDelegate.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDynamicLinks
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notifications = Notifications()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        notifications.messaging.delegate = notifications
        notifications.notificationCenter.delegate = notifications
        notifications.requestAutorization()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = MainVC()
        let rootNC = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let userActivity = userActivity.webpageURL {
            let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity) { dynamickClick, error in
                if let error = error {
                    print(error)
                    return
                }
                
                if let dynamickClick = dynamickClick {
                    self.handleIncomingDynamicLink(dynamickClick)
                }
            }
            
            return handled
        } else {
            return false
        }
    }
    
    private func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard
            let url = dynamicLink.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems
        else { return }
        
        for queryItem in queryItems {
            print(queryItem.name)
        }
        
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
//        return application(app, open: url,
//                           sourceApplication: options[UIApplication.OpenURLOptionsKey
//                                                        .sourceApplication] as? String,
//                           annotation: "")
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        } else {
            return false
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        } else {
            return false
        }
    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device token is: ", token)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError
        error: Error) {
        
        print("Failed to register: \(error)")
    }
}

