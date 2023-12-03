//
//  CozyEatsApp.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/5/23.
//

import SwiftUI
import Firebase
import FirebaseAnalytics

@main
struct CozyEatsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
