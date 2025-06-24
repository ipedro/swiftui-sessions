//
//  CombineSelectiveUpdatesDemoApp.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import SwiftUI

@main
struct CombineSelectiveUpdatesDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/// Watch the console output to see the difference in view update patterns.
struct ContentView: View {
    var body: some View {
        let _ = Self._printChanges()

        TabView {
            /// Traditional approach: All property changes trigger all view updates
            ObservableContentView().tabItem {
                Label("Observable", systemImage: "triangle")
            }

            /// Selective approach: Only subscribed property changes trigger updates
            PublishedContentView().tabItem {
                Label("Published", systemImage: "star")
            }
        }
    }
}

#Preview {
    ContentView()
}
