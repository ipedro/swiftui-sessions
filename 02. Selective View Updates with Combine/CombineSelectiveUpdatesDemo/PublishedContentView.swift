//
//  PublishedContentView.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import Combine
import SwiftUI

/// Data model using individual @Published properties without ObservableObject conformance.
/// This allows us to subscribe to specific property changes rather than all changes.
/// Each @Published property becomes an independent publisher that views can selectively observe.
@MainActor
final class PublishedDataModel {
    /// Only views that explicitly subscribe to model.$header will update when this changes.
    @Published var header = "Published" {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
    
    /// Only views that explicitly subscribe to model.$items will update when this changes.
    @Published var items = [ListItem]() {
        willSet { print("\(Self.self): \(#function) changed.") }
    }

    /// Only views that explicitly subscribe to model.$count will update when this changes.
    @Published var count = 0 {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
}

/// Demonstrates selective view updates using Combine publishers.
/// This view manually manages subscriptions to specific model properties,
/// ensuring only relevant changes trigger re-renders.
struct PublishedContentView: View {
    /// We store the model as @State rather than @StateObject because we don't want
    /// automatic observation of all properties. Instead, we'll selectively subscribe
    /// to only the properties we care about.
    @State private var model = PublishedDataModel()
    
    /// Local state that mirrors the model's items property.
    /// This state is updated only when model.$items publishes a new value,
    /// creating a selective binding to just the items data.
    @State private var items = [ListItem]()
    
    /// Local state that mirrors the model's header property.
    /// This creates isolation from other model changes - only header changes
    /// will cause this state (and dependent views) to update.
    @State private var header = ""

    var body: some View {
        let _ = Self._printChanges()

        NavigationStack {
            ListView(items: $items).toolbar {
                ToolbarItem(placement: .principal) {
                    HeaderView(header: $header)
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("Update Count in Model") {
                            /// This change WON'T trigger any view updates because no view
                            /// subscribes to model.$count. This demonstrates the power of
                            /// selective observation - irrelevant data changes don't cause UI churn.
                            model.count += 1
                        }
                        Button("Update Items in Model") {
                            /// This change WILL trigger updates, but only in views that depend on items.
                            model.items.appendItem()
                        }
                    }
                }
            }
        }
        /// Selective subscription to items changes.
        /// This creates a one-way data flow from model to local state.
        .onReceive(model.$items) { newValue in
            if items != newValue { items = newValue }
        }
        /// Selective subscription to header changes.
        .onReceive(model.$header) { newValue in
            if header != newValue { header = newValue }
        }
        /// Two-way binding: propagate local changes back to the model.
        /// This ensures that if the view modifies items (e.g., through ListView),
        /// those changes are reflected in the model for other potential observers.
        .onChange(of: items) {
            if items != model.items { model.items = items }
        }
        /// Two-way binding: propagate local header changes back to the model.
        .onChange(of: header) {
            if header != model.header { model.header = header }
        }
    }
}

#Preview {
    PublishedContentView()
}
