//
//  SignInWithEmailView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-19.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

struct SignInWithEmailView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State var user: UserViewModel = UserViewModel()
    @State private var showAlert = false
    @State private var errString:String = ""
    @Binding var showSheet: Bool
    @Binding var action:LoginView.Action?
    var body: some View {
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
                    FBAuth.authenticate(withEmail: self.user.email, password: self.user.password) { (result, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("Logged in as \(String(describing: result?.user.uid))")
                            self.user.email = ""
                            self.user.password = ""
                        }
                        
                    }
//                    FBAuth.authenticate(withEmail: self.user.email,
//                                                password: self.user.password) { (result, error) in
//                                                    if let error = error {
//                                                        print(error.rawValue)
//                                                        self.showAlert = true
//                                                        self.errString = error.rawValue
//                                                        return
//                                                    }
//                                                    print("Logged in as \(String(describing: result?.user.uid))")
//                                                    self.user.email = ""
//                                                    self.user.password = ""
//                    }
                }) {
                    Text("Login")
                        .padding(.vertical, 15)
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    self.action = .signUp
                    self.showSheet = true
                }) {
                    Text("Sign Up")
                        .padding(.vertical, 15)
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Login Error"), message: Text(self.errString), dismissButton:.default(Text("OK")))
            }
        }
        .padding(.top, 100)
        .frame(width: 300)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
    }
}

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView(showSheet: .constant(false), action: .constant(.signUp))
    }
}
