//
//  ProfileView.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/1/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        // if there's a logged in user
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundStyle(Color.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(user.fullName)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .tint(Color(.systemGray))
                        }
                    }
                }
                
                Section("General") {
                    HStack {
                        SettingRowView(imageName: "gear",
                                       title: "version",
                                       tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.subheadline)
                    }
                }
                
                Section("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingRowView(imageName: "arrow.left.circle.fill",
                                       title: "Sign out",
                                       tintColor: .red)
                    }
                    
                    Button {
                        print("Delete Account")
                    } label: {
                        SettingRowView(imageName: "xmark.circle.fill",
                                       title: "Delete Account",
                                       tintColor: .red)
                    }
                }
                
                //MARK: - Swiftful Thinking
                Section("Upgrade your account") {
                    Button {
                        // Toggle Premium
                        Task {
                            try await viewModel.updateUserPremiumStatus()
                        }
                    } label: {
                        Text("Toggle Premium Status")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: UIScreen.main.bounds.width - 64, height: 40)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    if let userPremiumStatus = user.isPremium {
                        Text("User's Permimum Status: \(userPremiumStatus)")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.main.bounds.width - 64, height: 40)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
