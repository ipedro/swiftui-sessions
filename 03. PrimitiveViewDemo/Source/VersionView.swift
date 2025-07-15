//
//  VersionView.swift
//  PrimitiveViewDemo
//
//  Created by Pedro Almeida on 27.06.25.
//

import SwiftUI

@MainActor
public protocol VersionView: View {
    associatedtype V1Body: View = EmptyView
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    @ViewBuilder @preconcurrency var v1Body: Self.V1Body { get }

    associatedtype V2Body: View = V1Body
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @ViewBuilder @preconcurrency var v2Body: Self.V2Body { get }

    associatedtype V3Body: View = V2Body
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @ViewBuilder @preconcurrency var v3Body: Self.V3Body { get }

    associatedtype V4Body: View = V3Body
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @ViewBuilder @preconcurrency var v4Body: Self.V4Body { get }

    associatedtype V5Body: View = V4Body
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    @ViewBuilder @preconcurrency var v5Body: Self.V5Body { get }

    associatedtype V6Body: View = V5Body
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 1.0, *)
    @ViewBuilder @preconcurrency var v6Body: Self.V6Body { get }

    associatedtype V7Body: View = V6Body
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    @ViewBuilder @preconcurrency var v7Body: Self.V7Body { get }
}

public extension VersionView where V1Body == EmptyView {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    var v1Body: EmptyView { EmptyView() }
}

public extension VersionView where V2Body == V1Body {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    var v2Body: V1Body { v1Body }
}

public extension VersionView where V3Body == V2Body {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    var v3Body: V2Body { v2Body }
}

public extension VersionView where V4Body == V3Body {
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    var v4Body: V3Body { v3Body }
}

public extension VersionView where V5Body == V4Body {
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    var v5Body: V4Body { v4Body }
}

public extension VersionView where V6Body == V5Body {
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 1.0, *)
    var v6Body: V5Body { v5Body }
}

public extension VersionView where V7Body == V6Body {
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    var v7Body: V6Body { v6Body }
}

public extension VersionView {
    var body: _VersionViewBody<Self> {
        _VersionViewBody(content: self)
    }
}

public struct _VersionViewBody<Content: VersionView>: PrimitiveView {
    let content: Content

    public static func makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            Content.V7Body._makeView(view: view[\.content.v7Body], inputs: inputs)
        } else if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 1.0, *) {
            Content.V6Body._makeView(view: view[\.content.v6Body], inputs: inputs)
        } else if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            Content.V5Body._makeView(view: view[\.content.v5Body], inputs: inputs)
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            Content.V4Body._makeView(view: view[\.content.v4Body], inputs: inputs)
        } else if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            Content.V3Body._makeView(view: view[\.content.v3Body], inputs: inputs)
        } else if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            Content.V2Body._makeView(view: view[\.content.v2Body], inputs: inputs)
        } else {
            Content.V1Body._makeView(view: view[\.content.v1Body], inputs: inputs)
        }
    }

    public static func makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            Content.V7Body._makeViewList(view: view[\.content.v7Body], inputs: inputs)
        } else if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 1.0, *) {
            Content.V6Body._makeViewList(view: view[\.content.v6Body], inputs: inputs)
        } else if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            Content.V5Body._makeViewList(view: view[\.content.v5Body], inputs: inputs)
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            Content.V4Body._makeViewList(view: view[\.content.v4Body], inputs: inputs)
        } else if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            Content.V3Body._makeViewList(view: view[\.content.v3Body], inputs: inputs)
        } else if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            Content.V2Body._makeViewList(view: view[\.content.v2Body], inputs: inputs)
        } else {
            Content.V1Body._makeViewList(view: view[\.content.v1Body], inputs: inputs)
        }
    }

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            Content.V7Body._viewListCount(inputs: inputs)
        } else if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 1.0, *) {
            Content.V6Body._viewListCount(inputs: inputs)
        } else if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            Content.V5Body._viewListCount(inputs: inputs)
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            Content.V4Body._viewListCount(inputs: inputs)
        } else if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            Content.V3Body._viewListCount(inputs: inputs)
        } else if Content.V2Body.self != Content.V1Body.self {
            Content.V2Body._viewListCount(inputs: inputs)
        } else {
            Content.V1Body._viewListCount(inputs: inputs)
        }
    }
}
