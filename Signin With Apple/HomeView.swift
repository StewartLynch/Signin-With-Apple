//
//  ContentView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @EnvironmentObject var userInfo: UserInfo
    var body: some View {
        NavigationView {
            Text("Logged in as \(userInfo.user.name)")
                .navigationBarTitle("Log In To Firebase")
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
                                                print(error.localizedDescription)
                                               case .success(let fbUser):
                                                   self.userInfo.user = fbUser
                                                   print(fbUser.sharedResources)
                                               }
                                           }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
