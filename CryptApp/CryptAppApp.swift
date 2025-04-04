//
//  CryptAppApp.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-26.
//

import SwiftUI

@main
struct CryptAppApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
        }
    }
}
