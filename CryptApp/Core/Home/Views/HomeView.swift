//
//  HomeView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var onClickPortfolio: Bool = false
    
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                header
                
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
        }
    }
    
    //MARK: - Header
    private var header: some View {
        HStack {
            CircleButtonView(iconName: onClickPortfolio ? "plus" : "info")
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
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { pCoin in
                CoinRowView(coin: pCoin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    //MARK: - Column Titles
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            
            Spacer()
            
            if onClickPortfolio {
                Text("Holdings")
            }
            
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
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
