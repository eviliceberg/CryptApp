//
//  ChartView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-12.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    
    private let maxY: Double
    private let minY: Double
    
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? .myGreen : .myRed
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(alignment: .leading) { chartYAxis.padding(.horizontal, 4) }
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundStyle(.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }

    }
    
    private var chartView: some View {
        GeometryReader { geo in
            Path { path in
                for index in data.indices {
                    let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = CGFloat( (1 - ((data[index] - minY) / yAxis)) * geo.size.height)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
                
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor.opacity(0), radius: 10, y: 0)
            .shadow(color: lineColor.opacity(1), radius: 10, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, y: 40)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((minY + (maxY - minY)/2)).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}
