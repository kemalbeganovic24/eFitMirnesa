//
//  eFitMirnesaApp.swift
//  eFitMirnesa
//
//  Created by Kemal Beganovic on 21. 8. 2026..
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelete : NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct eFitMirnesaApp: App {
    @UIApplicationDelegateAdaptor(AppDelete.self) var appDelegate
    @StateObject private var viewModel = MemberViewModel()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(viewModel)
        }
    }
}
