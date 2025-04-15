//
//  DetailView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-09.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            } else {
                ProgressView()
            }
        }
       
    }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    @State private var showText: Bool = false
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    
                    overViewTitle
                    
                    descriptionSection
                    
                    overviewSection
                    
                    additionalDetailSection
                    
                    linksSection
                }
                .padding(16)
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navBarTrailingItems
            }
        }
        
    }
    
    @ViewBuilder
    private var overViewTitle: some View {
        Text("Overview")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        Divider()
    }
    
    @ViewBuilder
    private var overviewSection: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let description = vm.coinDescription, !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .lineLimit(showText ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showText.toggle()
                        }
                    } label: {
                        Text(showText ? "Show less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var linksSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let webSiteURL = vm.webSiteURL, let url = URL(string: webSiteURL) {
                Link("Website", destination: url)
            }
            
            if let redditURL = vm.redditURL, let url = URL(string: redditURL) {
                Link("Reddit", destination: url)
            }
        }
        .font(.headline)
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var navBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(.accent)
            
            AsyncImage(url: URL(string: vm.coin.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .clipShape(.circle)
            } placeholder: {
                ProgressView()
                    .frame(width: 25)
            }

        }
    }
    
    @ViewBuilder
    private var additionalDetailSection: some View {
        Text("Additional Details")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        Divider()
        
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: DeveloperPreview.instance.coin)
    }
}
