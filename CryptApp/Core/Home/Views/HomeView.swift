//
//  HomeView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var onClickPortfolio: Bool = false
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                header
                
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
    
}

#Preview {
    NavigationStack {
        HomeView()
            .toolbar(.hidden)
    }
}
