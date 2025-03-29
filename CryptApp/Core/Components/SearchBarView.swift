//
//  SearchBarView.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-29.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    text.isEmpty ? .secondaryText : .accent
                )
            
            TextField("Search by name or symbol...", text: $text)
                .foregroundStyle(.accent)
                .autocorrectionDisabled()
                .overlay(alignment: .trailing) {
                    if !text.isEmpty {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.accent)
                            .padding(10)
                            .offset(x: 10)
                            .onTapGesture {
                                UIApplication.shared.endEditing()
                                self.text.removeAll()
                            }
                    }
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.background)
                .shadow(color: .accent.opacity(0.15), radius: 10)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .animation(.spring, value: text)
    }
}

#Preview {
    SearchBarView(text: .constant(""))
}
