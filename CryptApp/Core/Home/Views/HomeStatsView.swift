//
//  HomeStatsView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-30.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var inPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.stats) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: inPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(inPortfolio: .constant(false))
        .environmentObject(HomeViewModel())
}
