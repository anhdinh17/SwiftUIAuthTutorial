//
//  ProfileView.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/1/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    //MARK: - Swiftful thinking
    private let preferenceOptions: [String] = ["Sport", "Music", "Books"]
    // Check if preference is in the user.preference array or not?
    private func isPreferenceSelected(preference: String) -> Bool {
        guard let user = viewModel.currentUser,
              let userPreference = user.preference
        else {
            return false
        }
        return userPreference.contains(preference)
    }
    
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
                Section("Update a field") {
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
                
                Section("Working with array") {
                    HStack {
                        ForEach(preferenceOptions, id: \.self) { preference in
                            Button {
                                Task {
                                    // if preference already in array, we delete it.
                                    if isPreferenceSelected(preference: preference){
                                        try await viewModel.removeUserPreference(preference: preference)
                                    } else {
                                        // Add to array
                                        try await viewModel.addUserPreference(preference: preference)
                                    }
                                }
                            } label: {
                                Text(preference)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                            // Nếu preference nằm trong array của user thì button có tint là green
                            .tint( isPreferenceSelected(preference: preference) ? .green : .red)
                        }
                    }
                    
                    Text("User Preferences: \((user.preference ?? []).joined(separator: ", "))")
                }
                
                Section("Add/remove a Custom Object") {
                    Button {
                        Task {
                             try await viewModel.addMovieObject()
                        }
                    } label: {
                        Text("Add a movie object")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button {
                        Task {
                             try await viewModel.removeMovieObject()
                        }
                    } label: {
                        Text("Remove a movie object")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
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
