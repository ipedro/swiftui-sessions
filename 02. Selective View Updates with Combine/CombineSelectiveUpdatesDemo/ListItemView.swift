//
//  ListItemView.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import SwiftUI

struct ListItemView: View {
    let item: ListItem

    var body: some View {
        let _ = Self._printChanges()
        HStack {
            Image(systemName: item.icon.rawValue)
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(item.description)
        }
    }
}

#Preview {
    ListItemView(
        item: ListItem(
            description: "Item",
            icon: .arrowtriangleDown
        )
    )
}
