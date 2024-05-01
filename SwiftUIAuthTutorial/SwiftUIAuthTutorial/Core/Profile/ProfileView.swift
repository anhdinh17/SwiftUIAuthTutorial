//
//  ProfileView.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/1/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        Text(User.MOCK_USER.initials)
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundStyle(Color.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(User.MOCK_USER.fullName)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(User.MOCK_USER.email)
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
                        print("Sign out")
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
            }
        }
    }
}

#Preview {
    ProfileView()
}
