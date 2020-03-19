//
//  SignInWithEmailView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-19.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

struct SignInWithEmailView: View {
    @State var user: UserViewModel = UserViewModel()
    var body: some View {
        VStack {
            TextField("Email Address",
                      text: self.$user.email)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            SecureField("Password", text: $user.password)
            HStack {
                Spacer()
                NavigationLink(destination: ForgotPasswordView()) {
                    Text("Forgot password")
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
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .padding(.vertical, 5)
                        .frame(width: 200)
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .frame(width: 300)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
    }
}

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView()
    }
}
