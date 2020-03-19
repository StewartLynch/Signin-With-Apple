//
//  ContentView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var appVM:AppVM
    var body: some View {
        NavigationView {
            Text("User is logged in!")
                .navigationBarTitle("Log In To Firebase Demo")
                .navigationBarItems(trailing: Button("Logout"){
                    FBAuth.logout { (result) in
                        print("Logged out \(result)")
                    }
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appVM: AppVM())
    }
}
