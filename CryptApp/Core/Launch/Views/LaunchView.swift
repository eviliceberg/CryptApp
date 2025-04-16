//
//  LaunchView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-16.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portfolio...".map({ String($0) })
    @State private var showText: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launchBackground.ignoresSafeArea()
            Image(.logoTransparent)
                .resizable()
                .frame(width: 100, height: 100)
            
            ZStack {
                if showText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundStyle(.launchAccent)
                                .fontWeight(.heavy)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(.scale.animation(.easeIn))
                }
                
            }
            .offset(y: 70)
        }
        .onAppear {
            showText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                if counter == loadingText.count - 1 {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
