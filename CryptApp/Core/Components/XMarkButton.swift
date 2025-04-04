//
//  XMarkButton.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-04.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

#Preview {
    XMarkButton()
}
