//
//  CoinRowView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-26.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            
            if showHoldingsColumn {
                holdingsColumn
            }
            
            rightColumn
                
        }
        .font(.subheadline)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .fontWeight(.bold)
                .foregroundStyle(.accent)
            
            Text(String(format: "%.2f", coin.priceChangePercentage24H ?? 0.0) + "%")
                .foregroundStyle((coin.priceChangePercentage24H ?? 0) == 0 ? .secondaryText : ((coin.priceChangePercentage24H ?? 0) >= 0) ? .myGreen : .myRed)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
    private var holdingsColumn: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .fontWeight(.bold)
                .foregroundStyle(.accent)
            
            Text((coin.currentHoldings ?? 0).description)
        }
        .foregroundStyle(.accent)
    }
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text(coin.rank.description)
                .font(.caption)
                .foregroundStyle(.secondaryText)
                .frame(minWidth: 30)
            
            AsyncImage(url: URL(string: coin.image)) { image in
                switch image {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 30, height: 30)
                case .failure:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(.accent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CoinRowView(coin: DeveloperPreview.instance.coin, showHoldingsColumn: true)
}
