//
//  ContentView.swift
//  VariadicViewDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import SwiftUI

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

#Preview("VSack Mirror") {
    let stack = VStack {
        Text("some text")
    }

    let mirror = Mirror(reflecting: stack)

    Text("\(mirror.children.map({ "\($0.label!): \($0.value)"}).joined(separator: "\n"))")
}

#Preview("ZStack Mirror") {
    let stack = ZStackLayout {
        Text("some text")
    }

    let mirror = Mirror(reflecting: stack)

    Text("\(mirror.children.map({ "\($0.label!): \($0.value)"}).joined(separator: "\n"))")
}
