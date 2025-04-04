//
//  CoinLogoView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-04.
//

import SwiftUI

struct CoinLogoView: View {
    
    let coin: CoinModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: coin.image)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(.circle)
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            
            Text(coin.symbol.uppercased())
                .foregroundStyle(.accent)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }

    }
}

#Preview {
    CoinLogoView(coin: DeveloperPreview.instance.coin)
}
