//
//  TestClassEO.swift
//  MyAppStatus
//
//  Created by Stewart Lynch on 10/13/19.
//  Copyright © 2019 CreaTECH Solutions. All rights reserved.
//

import SwiftUI
import FirebaseAuth


class UserInfo: ObservableObject {
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    
    @Published var isUserAuthenticated: FBAuthState = .undefined
    @Published var user: FBUser = FBUser(uid: "", name: "", email: "", sharedResources: "")
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    // Mark: - Auth
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            guard let user = user else {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
            print("Successfully authenticated user with uid: \(user.uid)")
        })
    }
}
