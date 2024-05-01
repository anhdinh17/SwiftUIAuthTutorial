//
//  SwiftUIAuthTutorialApp.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 4/30/24.
//

import SwiftUI
import Firebase

@main
struct SwiftUIAuthTutorialApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
