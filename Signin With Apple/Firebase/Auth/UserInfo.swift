//
//  UserInfo.swift
//  Firebase Login
//
//  Created by Stewart Lynch on 2020-03-20.
//  Copyright © 2020 Stewart Lynch. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserInfo: ObservableObject {
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    @Published var isUserAuthenticated: FBAuthState = .undefined
    @Published var user: FBUser = FBUser(uid: "", name: "", email: "")
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            guard let user = user else {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
            FBFirestore.retrieveFBUser(uid: user.uid) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    self.user = user
                }
            }
        })

    }
}
