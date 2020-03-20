//
//  ForgotPasswordView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-19.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State var user: UserViewModel = UserViewModel()
//    @State private var email:String = ""
    @State private var showCompletion = false
    @State private var title = ""
    @State private var message = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter email address", text: $user.email).autocapitalization(.none).keyboardType(.emailAddress)
                
                Button(action: {
                    FBAuth.resetPassword(email: self.user.email) { (title, message) in
                        self.title = title
                        self.message = message
                        self.showCompletion = true
                    }
                }) {
                    Text("Reset")
                        .frame(width: 200)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .opacity(user.isEmailValid(_email: user.email) ? 1 : 0.75)
                        .foregroundColor(.white)
                }
                .disabled(!user.isEmailValid(_email: user.email))
                Spacer()
            }.padding(.top)
                .frame(width: 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .navigationBarTitle("Password Reset", displayMode: .inline)
                .alert(isPresented: $showCompletion) {
                    Alert(title: Text(self.title), message: Text(self.message), dismissButton: .default(Text("OK")) {
                        self.presentationMode.wrappedValue.dismiss()
                    })
            }
            .navigationBarTitle("Request a password reset", displayMode: .inline)
        }
    }
}


struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
