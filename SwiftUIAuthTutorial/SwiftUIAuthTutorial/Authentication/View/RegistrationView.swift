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
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                
                // Use ZStack to display checkmark
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeHolder: "Confirm your password",
                              isSecureField: true)
                    
                    // Check for password and confirm password to be the same
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Sign up button
            Button {
                Task {
                   try await viewModel.createUserSwiftfulThinking(withEmail: email,
                                         password: password,
                                         fullName: fullName)
                }
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
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
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

//MARK: - Validate the fields
extension RegistrationView: AuthenticationFormProtocol {
    var isFormValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && !fullName.isEmpty
        && confirmPassword == password
    }
}

#Preview {
    RegistrationView()
}
