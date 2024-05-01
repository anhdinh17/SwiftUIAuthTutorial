//
//  LoginView.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 4/30/24.
//

import SwiftUI

struct LoginView: View {
    @State var userEmail: String = ""
    @State var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // Image
                Image("fireImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding(.vertical, 32)
                
                // Form fields
                VStack(spacing: 32) {
                    InputView(text: $userEmail, title: "Email Address", placeHolder: "Enter your email")
                        .textInputAutocapitalization(.never)
                    InputView(text: $password, title: "Password", placeHolder: "Enter your password", isSecureField: true)
                }
                .padding(.horizontal)
                
                // Sign in button
                Button {
                    
                } label: {
                    HStack {
                        Text("SIGN IN")
                            
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(Color.white)
                    .fontWeight(.semibold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 45)
                }
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 20)
                
                Spacer()
                
                // Sign up button
                NavigationLink {
                    RegistrationView()
                        // hide nav bar back button
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Text("Don't have an account?")
                        
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
