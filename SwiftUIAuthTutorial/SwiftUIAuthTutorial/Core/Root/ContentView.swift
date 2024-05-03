//
//  ContentView.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 4/30/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                // If user logged in,
                // show ProfileView
                ProfileView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
