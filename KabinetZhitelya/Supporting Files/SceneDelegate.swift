//
//  SceneDelegate.swift
//  KabinetZhitelya
//
//  Created by user191208 on 3/3/21.
//  Copyright © 2021 user191208. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

protocol DeeplinkDelegate: AnyObject {
    func showScreen(page: Deeplinks)
}

enum Deeplinks: String {
    case tickets = "https://lk2.eis24.me/#/tickets/list/"
    case requests = "https://lk2.eis24.me/#/requests/list/"
    case accruals = "https://lk2.eis24.me/#/accruals/all/"
    case counters = "https://lk2.eis24.me/#/meters/list/"
    case news = "https://lk2.eis24.me/#/news/list/"
}

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    weak var deeplinksDelegate: DeeplinkDelegate?
    
    static func shared() -> SceneDelegate {
        let scene = UIApplication.shared.connectedScenes.first
        let sd: SceneDelegate = (((scene?.delegate as? SceneDelegate)!))
        return sd
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        window?.overrideUserInterfaceStyle = .light
        guard let winScene = (scene as? UIWindowScene) else { return }
        cheackLoginStatus(winScene: winScene)
        
        if let userActivity = connectionOptions.userActivities.first {
            guard let urlString = userActivity.webpageURL?.absoluteString else { return }
            let page = urlString.stringToEnum()
            deeplinksDelegate?.showScreen(page: page)
        }
    }
    
    private func cheackLoginStatus(winScene: UIWindowScene) {
        let token = UserDefaults.standard.object(forKey: "token")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if token as? String != "1"  {
            window = UIWindow(frame: winScene.coordinateSpace.bounds)
            window?.windowScene = winScene
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            window?.makeKeyAndVisible()
            window?.overrideUserInterfaceStyle = .light
        } else {
            window = UIWindow(frame: winScene.coordinateSpace.bounds)
            window?.windowScene = winScene
            let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            window?.rootViewController = vc
            deeplinksDelegate = vc
            window?.makeKeyAndVisible()
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        guard let urlString = userActivity.webpageURL?.absoluteString else { return }
        let page = urlString.stringToEnum()
        deeplinksDelegate?.showScreen(page: page)
        
        if let userActivity = userActivity.webpageURL {
            print(userActivity)
            let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity) { dynamickClick, error in
                
                if let error = error {
                    print(error)
                    return
                }
                
                if let dynamickClick = dynamickClick {
                    self.handleIncomingDynamicLink(dynamickClick)
                }
            }
            print(handled)
            
//            return handled
        } else {
//            return false
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

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

