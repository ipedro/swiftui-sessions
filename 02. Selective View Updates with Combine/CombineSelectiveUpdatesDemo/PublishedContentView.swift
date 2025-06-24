//
//  PublishedContentView.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import Combine
import SwiftUI

@MainActor
final class PublishedDataModel {
    // Any Combine Publisher works, PassthroughSubject, CurrentValueSubject, AnyPublisher, and so on.
    @Published var header = "Published" {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
    @Published var items = [ListItem]() {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
    @Published var count = 0 {
        willSet { print("\(Self.self): \(#function) changed.") }
    }
}

struct PublishedContentView: View {
    @State private var model = PublishedDataModel()
    @State private var items = [ListItem]()
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
                            // won't trigger updates in the view
                            model.count += 1
                        }
                        Button("Update Items in Model") {
                            model.items.appendItem()
                        }
                    }
                }
            }
        }
        // receive values from model
        .onReceive(model.$items) { newValue in
            if newValue != items {
                items = newValue
            }
        }
        .onReceive(model.$header) { newValue in
            if newValue != header {
                header = newValue
            }
        }
        // send values back to model
        .onChange(of: items) {
            if items != model.items {
                model.items = items }
            }
        .onChange(of: header) {
            if header != model.header {
                model.header = header
            }
        }
    }
}

#Preview {
    PublishedContentView()
}
