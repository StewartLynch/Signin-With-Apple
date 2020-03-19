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
            VStack {
                TextField("Email Address",
                          text: self.$user.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                SecureField("Password", text: $user.password)
                HStack {
                    Spacer()
                    Button(action: {
                        self.action = .resetPW
                        self.showSheet = true
                    }) {
                        Text("Forgot Password")
                    }
                }.padding(.bottom)
                VStack(spacing: 10) {
                    Button(action: {
                        
                    }) {
                        Text("Login")
                    }
                    .padding(.vertical, 5)
                    .frame(width: 200)
                    .background(Color.green)
                    .foregroundColor(.white)
                    
                    Button(action: {
                        self.action = .signUp
                        self.showSheet = true
                    }) {
                        Text("Sign Up")
                    }
                    .padding(.vertical, 5)
                    .frame(width: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    
                }
            }
            .padding()
            .frame(width: 300)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            SignInWithAppleView().frame(width: 200, height: 50)
            Spacer()
        }.sheet(isPresented: $showSheet) {
            if self.action == .signUp {
                SignUpView()
            } else {
                Text("Change Password")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        
    }
}
