//
//  CircleButtonView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-26.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .fill(Color.background)
            )
            .shadow(color: .accent.opacity(0.25), radius: 10)
            .padding()
    }
}

#Preview {
    VStack {
        CircleButtonView(iconName: "info")
        CircleButtonView(iconName: "plus")
            .colorScheme(.light)
    }
}
