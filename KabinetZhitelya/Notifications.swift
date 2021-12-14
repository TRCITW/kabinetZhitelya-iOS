//
//  Notifications.swift
//  KabinetZhitelya
//
//  Created by Andreas on 23.05.2021.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let messaging = Messaging.messaging()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func getFCMToken(completion: @escaping (Result<String, Error>) -> Void) {
        Messaging.messaging().token { token, error in
          if let error = error {
            completion(.failure(error))
            return
          } else if let token = token {
            completion(.success(token))
          }
        }
    }
}

extension Notifications: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    }
    
}
