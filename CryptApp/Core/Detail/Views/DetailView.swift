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
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("")
                    .frame(height: 150)
                
                overviewSection
                
                additionalDetailSection
                

            }
            .padding(16)
        }
        .navigationTitle(vm.coin.name)
        
    }
    
    @ViewBuilder
    private var overviewSection: some View {
        Text("Overview")
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
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
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
