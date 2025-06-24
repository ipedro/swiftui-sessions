//
//  ContentView.swift
//  VariadicViewDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    let content = ForEach(0..<5) { index in
        Text("Preview \(index)")
    }

    Group {
        content
    }
    .border(Color.blue)

    Divider()

    VStack {
        content
    }
    .border(Color.blue)
}

#Preview {
    let stack = VStack {
        Text("some text")
    }

    let mirror = Mirror(reflecting: stack)

    Text("\(mirror.children.map({ "\($0.label!): \($0.value)"}).joined(separator: "\n"))")
}

#Preview {
    let group = Group {
        Text("some text")
    }

    let mirror = Mirror(reflecting: group)

    Text("\(mirror.children.map({ "\($0.label!): \($0.value)"}).joined(separator: "\n"))")
}
