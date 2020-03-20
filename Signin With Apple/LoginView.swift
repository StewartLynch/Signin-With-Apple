//
//  LoginView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    enum Action {
        case signUp, resetPW
    }
    @State private var user = UserViewModel()
    @State private var showSheet = false
    @State private var action:Action?
    var body: some View {
        VStack {
            SignInWithEmailView(showSheet: $showSheet, action: $action)
            SignInWithAppleView().frame(width: 200, height: 50)
            Spacer()
        }.sheet(isPresented: $showSheet) {
            if self.action == .signUp {
                SignUpView()
            } else {
                ForgotPasswordView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        
    }
}
