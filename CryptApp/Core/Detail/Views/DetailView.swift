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
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing DetailView For \(coin.name)")
    }
    
    var body: some View {
        VStack {
            if let details = vm.coinDetails {
                Text(details.id ?? "")
                Text(details.description?.en ?? "")
            }

        }
        
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.instance.coin)
}
