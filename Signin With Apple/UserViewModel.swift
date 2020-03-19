//
//  UserViewModel.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation

struct UserViewModel: Codable {
    var uid: String?
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
}
