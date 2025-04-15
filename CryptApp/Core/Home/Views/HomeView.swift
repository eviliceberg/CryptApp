//
//  HomeView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var onClickPortfolio: Bool = false
    
    @State private var showPortfolio: Bool = false
    @State private var showSettingsView: Bool = false
    
    @EnvironmentObject var vm: HomeViewModel
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDatailView: Bool = false
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
                .sheet(isPresented: $showPortfolio) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            VStack {
                header
                
                HomeStatsView(inPortfolio: $onClickPortfolio)
                
                SearchBarView(text: $vm.searchText)
                
                columnTitles
                
                if !onClickPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                } else {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer()
            }
            .animation(.spring, value: onClickPortfolio)
            .animation(.smooth, value: vm.coins)
            .navigationDestination(isPresented: $showDatailView) {
                DetailLoadingView(coin: $selectedCoin)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
    }
    
    //MARK: - Header
    private var header: some View {
        HStack {
            CircleButtonView(iconName: onClickPortfolio ? "plus" : "info")
                .onTapGesture {
                    if onClickPortfolio {
                        showPortfolio = true
                    } else {
                        showSettingsView = true
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $onClickPortfolio)
                )
            
            Text(onClickPortfolio ? "Portfolio" : "Live Prices")
                .frame(maxWidth: .infinity)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(.accent)
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(.degrees(onClickPortfolio ? 180 : 0))
                .onTapGesture {
                    onClickPortfolio.toggle()
                }
        }
        .padding(.horizontal, 16)
    }
    //MARK: - Lists
    private var allCoinsList: some View {
        List {
            ForEach(vm.coins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDatailView.toggle()
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { pCoin in
                CoinRowView(coin: pCoin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: pCoin)
                    }
            }
        }
        .listStyle(.plain)
    }
    //MARK: - Column Titles
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
                    .rotationEffect(.degrees(vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    if vm.sortOption == .rank {
                        vm.sortOption = .rankReversed
                    } else {
                        vm.sortOption = .rank
                    }
                }
            }
            
            Spacer() 
            
            if onClickPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1 : 0)
                        .rotationEffect(.degrees(vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        if vm.sortOption == .holdings {
                            vm.sortOption = .holdingsReversed
                        } else {
                            vm.sortOption = .holdings
                        }
                    }
                   
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                   
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
                    .rotationEffect(.degrees(vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    if vm.sortOption == .price {
                        vm.sortOption = .priceReversed
                    } else {
                        vm.sortOption = .price
                    }
                }
            }
    
            Button {
                withAnimation(.linear(duration: 2)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(.degrees(vm.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundStyle(.secondaryText)
        .padding(.horizontal)
    }
    
}

#Preview {
    NavigationStack {
        HomeView()
            .toolbar(.hidden)
    }
    .environmentObject(HomeViewModel())
}
