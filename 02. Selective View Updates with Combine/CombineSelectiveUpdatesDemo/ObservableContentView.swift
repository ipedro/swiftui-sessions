//
//  ObservableContentView.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import Combine
import SwiftUI

/// Traditional ObservableObject approach where ANY property change triggers ALL observing views to update.
/// This demonstrates the "wide net" update behavior that can cause performance issues in complex UIs.
@MainActor
final class ObservableDataModel: ObservableObject {
    /// Changing this property will trigger `objectWillChange` for the entire model
    @Published var header = "Observable" {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
    
    /// Changing this property will trigger `objectWillChange` for the entire model
    @Published var items = [ListItem]() {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
    
    /// Even though no UI component directly displays this value, changing it will still
    /// trigger view updates for ANY view that observes this model instance.
    /// This is the core inefficiency we're addressing with selective updates.
    @Published var count = 0 {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
}

/// Demonstrates traditional SwiftUI data binding with ObservableObject.
/// Notice how this view will re-render whenever ANY property in the model changes,
/// even properties that aren't used by the view or its children.
struct ObservableContentView: View {
    /// Using @StateObject creates a dependency on the entire model.
    /// Any @Published property change in ObservableDataModel will trigger this view to update.
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
                            /// This change will trigger unnecessary updates in HeaderView and ListView
                            /// even though neither component uses or displays the count value.
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
