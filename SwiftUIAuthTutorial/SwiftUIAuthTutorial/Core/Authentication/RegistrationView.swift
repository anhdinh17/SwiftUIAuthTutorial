//
//  RegistrationView.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/1/24.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @State var email: String = ""
    @State var fullName: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    var body: some View {
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
                InputView(text: $email,
                          title: "Email Address",
                          placeHolder: "Enter your email")
                .textInputAutocapitalization(.never)
                
                InputView(text: $fullName,
                          title: "Full Name",
                          placeHolder: "Enter your full name")
                
                InputView(text: $password,
                          title: "Password",
                          placeHolder: "Enter your password",
                          isSecureField: true)
                
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeHolder: "Confirm your password",
                          isSecureField: true)
            }
            .padding(.horizontal)
            
            // Sign up button
            Button {
                
            } label: {
                HStack {
                    Text("SIGN UP")
                    
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
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                    
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    RegistrationView()
}
