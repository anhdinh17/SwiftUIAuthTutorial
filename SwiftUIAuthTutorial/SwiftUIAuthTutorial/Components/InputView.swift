//
//  InputView.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 4/30/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeHolder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(Color(.darkGray))
            
            if isSecureField {
                // Create password field
                SecureField(placeHolder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeHolder, text: $text)
                    .font(.system(size: 14))
            }
            
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeHolder: "Type in your email")
}
