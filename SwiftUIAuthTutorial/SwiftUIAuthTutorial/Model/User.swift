//
//  User.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/1/24.
//

import Foundation

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    //MARK: - Swiftful Thinking
    let isPremium: Bool?
    var preference: [String]?
    var favoriteMovie: Movie?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        } else {
            return ""
        }
    }
    
    
    //---- CodingKeys -----
    // this encodes to snake case and decode from snake case to our camal case
    // This is needed if you have to work with other teams and they have snake case (or other rules) in DB
    // In this app example, I am not using this
//    enum CodingKeys: CodingKey {
//        case id
//        case fullName
//        case email
//        case isPremium
//    }
//    
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.id, forKey: .id)
//        try container.encode(self.fullName, forKey: .fullName)
//        try container.encode(self.email, forKey: .email)
//        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
//    }
//    
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.fullName = try container.decode(String.self, forKey: .fullName)
//        self.email = try container.decode(String.self, forKey: .email)
//        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
//    }
}

extension User {
    static let MOCK_USER = User(id: UUID().uuidString,
                                fullName: "Kobe Bryan",
                                email: "kobebryan@email.com",
                                isPremium: false,
                                favoriteMovie: Movie(id: UUID().uuidString,
                                                     title: "Titanic",
                                                     isPopular: true))
}
