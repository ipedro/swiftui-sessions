//
//  ContentView.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 23.06.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let _ = Self._printChanges()
        TabView {
            ObservableContentView().tabItem {
                Label("Observable", systemImage: "triangle")
            }
            PublishedContentView().tabItem {
                Label("Published", systemImage: "star")
            }
        }
    }
}

#Preview {
    ContentView()
}
