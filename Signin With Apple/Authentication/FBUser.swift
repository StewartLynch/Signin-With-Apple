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
}

extension FBUser: DocumentSerializable {
    
    init?(documentData: [String : Any]) {
        let uid = documentData[FBKeys.User.uid] as? String ?? ""
        let name = documentData[FBKeys.User.name] as? String ?? ""
        let email = documentData[FBKeys.User.email] as? String ?? ""
        
        self.init(uid: uid,
                  name: name,
                  email: email)
    }
}
