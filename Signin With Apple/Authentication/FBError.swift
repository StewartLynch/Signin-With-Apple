//
//  FBError.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation

struct FBAuthError: Error {
    static let noAuthDataResult = NSError(domain: "No Auth Data Result", code: 400, userInfo: nil)
    static let noCurrentUser = NSError(domain: "No Current User", code: 401, userInfo: nil)
    static let noDocumentSnapshot = NSError(domain: "No Document Snapshot", code: 402, userInfo: nil)
    static let noSnapshotData = NSError(domain: "No Snapshot Data", code: 403, userInfo: nil)
    static let noUser = NSError(domain: "No User", code: 404, userInfo: nil)
}

struct SignInWithAppleAuthError: Error {
    static let noAuthDataResult = NSError(domain: "No Auth Data Result", code: 300, userInfo: nil)
    static let noIdentityToken = NSError(domain: "Unable to fetch identity token", code: 301, userInfo: nil)
    static let noIdTokenString = NSError(domain: "Unable to serialize token string from data", code: 302, userInfo: nil)
    static let noAppleIDCredential = NSError(domain: "Unable to create Apple ID Credential", code: 303, userInfo: nil)
}

struct CreateUserError: Error {
    
}
