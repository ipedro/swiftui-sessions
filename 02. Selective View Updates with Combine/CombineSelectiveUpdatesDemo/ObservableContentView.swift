//
//  ObservableContentView.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import Combine
import SwiftUI

@MainActor
final class ObservableDataModel: ObservableObject {
    @Published var header = "Observable" {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
    @Published var items = [ListItem]() {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
    @Published var count = 0 {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
}

struct ObservableContentView: View {
    @StateObject private var model = ObservableDataModel()

    var body: some View {
        let _ = Self._printChanges()
        NavigationStack {
            ListView(items: $model.items).toolbar {
                ToolbarItem(placement: .principal) {
                    HeaderView(header: $model.header)
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("Update Count in Model") {
                            // will trigger updates in the view
                            model.count += 1
                        }
                        Button("Update Items in Model") {
                            model.items.appendItem()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ObservableContentView()
}
