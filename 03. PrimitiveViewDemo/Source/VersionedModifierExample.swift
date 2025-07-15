//
//  VersionedUnderlineModifier.swift
//  PrimitiveViewDemo
//
//  Created by Pedro Almeida on 15.07.25.
//

import SwiftUI

struct VersionedUnderlineModifier: VersionViewModifier {
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func v4Body(content: Content) -> some View {
        content.underline()
    }
    
    func v1Body(content: Content) -> some View {
        content.background(
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        )
    }
}

#Preview {
    Text("My text")
        .modifier(
            VersionedUnderlineModifier()
        )
}
