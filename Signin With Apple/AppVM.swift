//
//  AppVM.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class AppVM: ObservableObject {
    @Published var user: UserViewModel?
    @Published var isLoggedIn: Bool?
    
}
