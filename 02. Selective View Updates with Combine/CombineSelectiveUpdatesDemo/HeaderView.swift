//
//  HeaderView.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import SwiftUI

struct HeaderView: View {
    @Binding var header: String

    var body: some View {
        let _ = Self._printChanges()
        HStack {
            Text(header.capitalized)
                .font(.headline)
            Button {
                header = String(header.shuffled())
            } label: {
                Image(systemName: "shuffle")
            }
        }
    }
}

#Preview {
    @Previewable @State
    var header = "Header"

    HeaderView(header: $header)
}
