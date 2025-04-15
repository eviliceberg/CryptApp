//
//  SettingsView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-15.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com")!
    let coffee = URL(string: "https://www.buymeacoffee.com")!
    let coinGeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://github.com/eviliceberg")!
    
    var body: some View {
        NavigationStack {
            List {
                swiftSection
                coinGeckoSection
                developerSection
                applicationSection
            }
            .tint(.blue)
            .navigationTitle("Settings")
            .listStyle(.grouped)
            .font(.headline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
    
    private var swiftSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(.rect(cornerRadius: 20))
                Text("This app was made by following a @SwiftfulThinking course on YouTube. It uses MVVM architecture, Combine and CoreData for storing data.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)
            }
            .padding(.vertical)
            Link(destination: youtubeURL) {
                Text("YouTube")
            }
            Link("Support his coffee addiction", destination: coffee)
        } header: {
            Text("Channel")
        }
    }
    
    
    
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(.coingecko)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(.rect(cornerRadius: 20))

            Text("The crypto currency data that is used in this app comes from a free API from Coin Gecko! Prices may be slightly delayed.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(.accent)
        }
        .padding(.vertical)
        Link("Visit Coin Gecko", destination: coinGeckoURL)
        } header: {
            Text("Coin Gecko")
        }
    }
    
    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(.rect(cornerRadius: 20))

            Text("This app was developed by Artem Golovchenko. This app is written on pure Swift with utilization of SwiftUI, Combine and networking.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(.accent)
        }
        .padding(.vertical)
            Link("Visit GitHub", destination: personalURL)
        } header: {
            Text("Developer")
        }
    }
    
    private var applicationSection: some View {
        Section {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        } header: {
            Text("Application")
        }
    }
}

#Preview {
    SettingsView()
}
