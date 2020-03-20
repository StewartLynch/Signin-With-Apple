//
//  FBUser.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation

struct FBUser: Identifiable {
    let id = UUID()
    let uid: String
    let name: String
    let email: String
    
    // App Specific property
    let sharedResources: String
    
    static func dataDict(uid: String, name: String, email: String) -> [String: Any] {
        var data: [String: Any]
        
        // If name is not "" this must be a new entry so add all first time data
        if name != "" {
            data = [
                FBKeys.User.uid: uid,
                FBKeys.User.name: name,
                FBKeys.User.email: email,
                FBKeys.User.sharedResources: "[]" // App Specific
            ]
        } else {
            // This is a subsequent entry so only merge uid and email so as not
            // to overrwrite any other data.
            data = [
                FBKeys.User.uid: uid,
                FBKeys.User.email: email
            ]
        }
        return data
    }
}

extension FBUser: DocumentSerializable {
    
    init?(documentData: [String : Any]) {
        let uid = documentData[FBKeys.User.uid] as? String ?? ""
        let name = documentData[FBKeys.User.name] as? String ?? ""
        let email = documentData[FBKeys.User.email] as? String ?? ""
        
        // App specific
        let sharedResources = documentData[FBKeys.User.sharedResources] as? String ?? ""
        
        self.init(uid: uid,
                  name: name,
                  email: email,
                  sharedResources: sharedResources // App specific
        )
    }
}
