//
//  TestClassEO.swift
//  MyAppStatus
//
//  Created by Stewart Lynch on 10/13/19.
//  Copyright © 2019 CreaTECH Solutions. All rights reserved.
//

import SwiftUI
import FirebaseAuth

enum FBAuthState {
    case undefined, signedOut, signedIn
}

class UserSettings: ObservableObject {
//    @Published var country:String = UserDefaults.standard.object(forKey: "country") as? String ?? "US" {
//        didSet {
//            UserDefaults.standard.set(country, forKey: "country")
//        }
//    }
//    @Published var showCompleted:Bool = UserDefaults.standard.bool(forKey: "showCompleted") {
//        didSet {
//            UserDefaults.standard.set(_showCompleted, forKey: "showCompleted")
//        }
//    }
    var devMode = false
    @Published var isUserAuthenticated: FBAuthState = .undefined
    @Published var user: FBUser = FBUser(uid: "", name: "", email: "")
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    // Mark: - Auth
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            guard let user = user else {
//                print("User is signed out")
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
            print("Successfully authenticated user with uid: \(user.uid)")
        })
    }
}
