//
//  ContentView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                Text("Color")
                    .foregroundStyle(.secondaryText)
                
                Text("Color")
                    .foregroundStyle(.accent)
                Text("Color")
                    .foregroundStyle(.myRed)
                Text("Color")
                    .foregroundStyle(.myGreen)
            }
        }
    }
}

#Preview {
    ContentView()
}
