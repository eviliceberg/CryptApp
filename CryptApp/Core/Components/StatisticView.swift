//
//  StatisticView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-29.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(.accent)
            
            HStack(spacing: 2) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(.degrees((stat.percentage ?? 0.0) > 0.0 ? 0 : 180))
                    .opacity((stat.percentage == 0.0 || stat.percentage == nil) ? 0 : 1)
                
                Text(stat.percentage?.asPercentString() ?? "")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundStyle((stat.percentage ?? 0.0) > 0.0 ? .myGreen : ((stat.percentage ?? 0.0) == 0.0 ? .secondaryText : .myRed))
        }
    }
}

#Preview {
    HStack {
        StatisticView(stat: DeveloperPreview.instance.stat)
        StatisticView(stat: DeveloperPreview.instance.stat2)
        StatisticView(stat: DeveloperPreview.instance.stat3)
    }
   
}
