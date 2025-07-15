//
//  VersionViewExample.swift
//  PrimitiveViewDemo
//
//  Created by Pedro Almeida on 15.07.25.
//

import SwiftUI

struct VersionViewExample: VersionView {
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    var v7Body: some View {
        Text("v7Body: \(ProcessInfo.processInfo.operatingSystemVersion.majorVersion)")
    }

    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 1.0, *)
    var v6Body: some View {
        Text("v6Body")
    }
    
    var v1Body: some View {
        Text("fallback")
    }
}

#Preview {
    VersionViewExample()
}
