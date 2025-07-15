//
//  PlatformViewExample.swift
//  PrimitiveViewDemo
//
//  Created by Pedro Almeida on 15.07.25.
//

import SwiftUI

struct PlatformViewExample: PlatformView {
    var macBody: some View {
        Text("Mac OS").padding()
    }

    var phoneBody: some View {
        Text("iPhone").background(Color.yellow)
    }

    var padBody: some View {
        Text("iPad")
    }
}

#Preview {
    PlatformViewExample()
}
