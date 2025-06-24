//
//  ListView.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import SwiftUI

struct ListView: View {
    @Binding var items: [ListItem]

    var body: some View {
        let _ = Self._printChanges()
        
        List(
            items.reversed(),
            rowContent: ListItemView.init
        ).toolbar {
            Button {
                items.appendItem()
            } label: {
                Image(systemName: "plus.circle.fill")
            }
        }
    }
}

#Preview {
    @Previewable @State
    var items = [ListItem]()

    NavigationStack {
        ListView(items: $items)
    }
}
