//
//  AuthViewModel.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/1/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

/// Protocol to validate the fields
// Screens having fields conform to this protocol
protocol AuthenticationFormProtocol {
    var isFormValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    // Let us know whether or not a user logged in
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        // Check if there's a user logged in
        // => contentView will know userSession has a value
        // => display ProfileView
        self.userSession = Auth.auth().currentUser
        
        /// Explain
        // we should check if there's a current user logged in.
        // If we don't, everytime we run the app, it will go to Login screen.
        // Because everytime we run the app, we create a ViewModel intsance, and userSession is nil
        // if we don't check.
        
        /// Fetch user
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            // Fetch user after sign in successfully.
            // If we don't fetchUser(), profileView will be blank
            // because it depends on self.currentUser
            await fetchUser()
        } catch {
            print("ERRO LOGGIN IN: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            // createUser() is an async func
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            
            // Encode User object just created
            // This is for FireStore
            let encodedUser = try Firestore.Encoder().encode(user)
            // Create a user in Firestore DB
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            // fetch user
            // The scenario is after we successfully create a user, we have to fetch user's data to populate it
            // in ProfileView
            await fetchUser()
        } catch {
            
        }
    }
    
    func signOut() {
        // We need to do 2 things
        // logout @ backend
        // AND set nil for userSession and currentUser
        do {
            // sign out from backend
            try Auth.auth().signOut()
            
            // wipe out user session and User Model and take us back to Login screen
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("ERROR LOGGING OUT: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        // Check if there's current user logged in
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // Get data at users/uid
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {
            return
        }
        // Decode
        // it goes to users/id and decode what in there into User model.
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("CURRENT USER: \(self.currentUser)")
    }
}
