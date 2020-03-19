//
//  MyTabsView.swift
//  MyAppsTasksCD
//
//  Created by Stewart Lynch on 10/28/19.
//  Copyright © 2019 Stewart Lynch. All rights reserved.
//

import SwiftUI

struct MyTabsView: View {
    @EnvironmentObject var userSettings:UserSettings
    @ObservedObject var appVM = AppVM()
    var body: some View {
        ZStack {
            if userSettings.isUserAuthenticated == .undefined {
                Text("Loading...")
            } else if userSettings.isUserAuthenticated == .signedOut {
                LoginView()
            } else if userSettings.isUserAuthenticated == .signedIn {
                TabView {
                    ContentView(appVM: appVM)
                        .tabItem {
                            Text("Content View")
                    }.tag(1)
                    Text("Tab Content 2")
                        .tabItem {
                            Text("Tab Label 2")
                    }.tag(2)
                }
            }
        }.onAppear {
            self.userSettings.configureFirebaseStateDidChange()
        }
        
    }
}

struct MyTabsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTabsView()
    }
}
    
