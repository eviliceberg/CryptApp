//
//  PortfolioView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-04.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantity: String = ""
    
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(text: $vm.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavBarItems
                }
            }
            .animation(.spring(duration: 0.3), value: showCheckmark)
            .animation(.spring, value: quantity)
            .onChange(of: vm.searchText) { oldValue, newValue in
                if newValue.isEmpty && !oldValue.isEmpty {
                    selectedCoin = nil
                    quantity = ""
                }
            }
        }
    }
    
    private func saveButtonPressed() {
        
        guard let coin = selectedCoin, let quantityDouble = Double(quantity) else { return }
        
        //save
        vm.updatePortfolio(coin: coin, amount: quantityDouble)
        
        // show checkmark
        showCheckmark = true
        
        selectedCoin = nil
        quantity = ""
        vm.searchText = ""
        
        //hide The Keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dismiss()
        }
        
    }
    
    private var trailingNavBarItems: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .foregroundStyle(.accent)
                .opacity(showCheckmark ? 1.0 : 0.0)
                .rotationEffect(showCheckmark ? .degrees(0) : .degrees(90))
            Button {
                saveButtonPressed()
            } label: {
                Text("Save")
            }
            .allowsHitTesting(Double(quantity) != nil)
        }
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding:")
                //Spacer()
                TextField("Ex. 1.41", text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
            .animation(.none, value: quantity)
        }
        .padding(.horizontal, 16)
        .padding(.vertical)
        .font(.headline)
    }
    
    private func getCurrentValue() -> Double {
        if let quantityDouble = Double(quantity) {
            
            let result = (selectedCoin?.currentPrice ?? 0.0) * quantityDouble
            
            return result
        }
        return 0.0
    }
    
    private var coinLogoList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.coins) { coin in
                    CoinLogoView(coin: coin)
                        .padding(4)
                        .frame(width: 75, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin == coin ? Color.myGreen : Color.clear, lineWidth: 1)
                        )
                        .onTapGesture {
                            withAnimation(.spring) {
                                updateSelectedCoin(coin)
                            }
                        }
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
            
        }
        .scrollIndicators(.hidden)
    }
    
    private func updateSelectedCoin(_ coin: CoinModel) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }), let amount = portfolioCoin.currentHoldings {
            quantity = amount.asString()
        } else {
            quantity = ""
        }
    }
    
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}
