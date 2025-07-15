//
//  VersionViewModifier.swift
//  PrimitiveViewDemo
//
//  Created by Pedro Almeida on 28.06.25.
//

import SwiftUI

@MainActor
protocol VersionViewModifier: ViewModifier {
    associatedtype V1Body: View = Self.Content
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    @ViewBuilder @preconcurrency func v1Body(content: Self.Content) -> Self.V1Body

    associatedtype V2Body: View = V1Body
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @ViewBuilder @preconcurrency func v2Body(content: Self.Content) -> Self.V2Body

    associatedtype V3Body: View = V2Body
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @ViewBuilder @preconcurrency func v3Body(content: Self.Content) -> Self.V3Body

    associatedtype V4Body: View = V3Body
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @ViewBuilder @preconcurrency func v4Body(content: Self.Content) -> Self.V4Body

    associatedtype V5Body: View = V4Body
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    @ViewBuilder @preconcurrency func v5Body(content: Self.Content) -> Self.V5Body

    associatedtype V6Body: View = V5Body
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 1.0, *)
    @ViewBuilder @preconcurrency func v6Body(content: Self.Content) -> Self.V6Body

    associatedtype V7Body: View = V6Body
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    @ViewBuilder @preconcurrency func v7Body(content: Self.Content) -> Self.V7Body
}

extension VersionViewModifier {
    func body(content: Content) -> _VersionViewModifierBody<Self> {
        _VersionViewModifierBody(modifier: self, content: content)
    }
}

extension VersionViewModifier where V1Body == Self.Content {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func v1Body(content: Self.Content) -> Self.V1Body {
        content
    }
}

extension VersionViewModifier where V2Body == V1Body {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func v2Body(content: Self.Content) -> Self.V2Body {
        v1Body(content: content)
    }
}

extension VersionViewModifier where V3Body == V2Body {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func v3Body(content: Self.Content) -> Self.V3Body {
        v2Body(content: content)
    }
}

extension VersionViewModifier where V4Body == V3Body {
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func v4Body(content: Self.Content) -> Self.V4Body {
        v3Body(content: content)
    }
}

extension VersionViewModifier where V5Body == V4Body {
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func v5Body(content: Self.Content) -> Self.V5Body {
        v4Body(content: content)
    }
}

extension VersionViewModifier where V6Body == V5Body {
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 1.0, *)
    func v6Body(content: Self.Content) -> Self.V6Body {
        v5Body(content: content)
    }
}

extension VersionViewModifier where Self.V7Body == Self.V6Body {
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    func v7Body(content: Self.Content) -> Self.V6Body {
        v6Body(content: content)
    }
}

struct _VersionViewModifierBody<Modifier: VersionViewModifier>: VersionView {
    let modifier: Modifier
    let content: Modifier.Content

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    var v7Body: some View {
        modifier.v7Body(content: content)
    }

    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 1.0, *)
    var v6Body: some View {
        modifier.v6Body(content: content)
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    var v5Body: some View {
        modifier.v5Body(content: content)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    var v4Body: some View {
        modifier.v4Body(content: content)
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    var v3Body: some View {
        modifier.v3Body(content: content)
    }

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    var v2Body: some View {
        modifier.v2Body(content: content)
    }
    
    var v1Body: some View {
        modifier.v1Body(content: content)
    }
}
