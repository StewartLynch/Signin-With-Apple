//
//  ContentView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var appVM:AppVM
    var body: some View {
        NavigationView {
            Text("Logged in as \(userSettings.user.name)")
                .navigationBarTitle("Log In To Firebase Demo")
                .navigationBarItems(trailing: Button("Logout"){
                    FBAuth.logout { (result) in
                        print("Logged out \(result)")
                    }
                })
                .onAppear {
                    guard  let uid = Auth.auth().currentUser?.uid else { return }
                 FBFirestore.retrieveFBUser(uid:uid) { (result) in
                                               switch result {
                                               case .failure(let error):
                                                   print(error)
                                               case .success(let fbUser):
                                                   self.userSettings.user = fbUser
                                               }
                                           }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appVM: AppVM())
    }
}
