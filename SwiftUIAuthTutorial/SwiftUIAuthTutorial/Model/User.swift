//
//  User.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/1/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        } else {
            return ""
        }
    }
}

extension User {
    static let MOCK_USER = User(id: UUID().uuidString, fullName: "Kobe Bryan", email: "kobebryan@email.com")
}
