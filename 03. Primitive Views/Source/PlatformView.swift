//
//  PlatformView.swift
//  PrimitiveViewDemo
//
//  Created by Pedro Almeida on 27.06.25.
//

import SwiftUI

@MainActor
public protocol PlatformView: View {
    associatedtype IOS: View = EmptyView
    var phoneBody: IOS { get }

    associatedtype PadOS: View = EmptyView
    var padBody: PadOS { get }

    associatedtype MacOS: View = EmptyView
    var macBody: MacOS { get }

    associatedtype TvOS: View = EmptyView
    var tvBody: TvOS { get }

    associatedtype VisionOS: View = EmptyView
    var visionBody: VisionOS { get }

    associatedtype WatchOS: View = EmptyView
    var watchBody: WatchOS { get }
}

public extension PlatformView where IOS == EmptyView {
    var phoneBody: IOS { EmptyView() }
}
public extension PlatformView where PadOS == EmptyView {
    var padBody: PadOS { EmptyView() }
}
public extension PlatformView where MacOS == EmptyView {
    var macBody: MacOS { EmptyView() }
}
public extension PlatformView where TvOS == EmptyView {
    var tvBody: TvOS { EmptyView() }
}
public extension PlatformView where VisionOS == EmptyView {
    var visionBody: VisionOS { EmptyView() }
}
public extension PlatformView where WatchOS == EmptyView {
    var watchBody: WatchOS { EmptyView() }
}

public extension PlatformView {
    var body: _PlatformViewBody<Self> {
        _PlatformViewBody(content: self)
    }
}

public struct _PlatformViewBody<Content: PlatformView>: PrimitiveView {
    let content: Content
    
    public static func makeView(view: _GraphValue<Self>, inputs: _ViewInputs) -> _ViewOutputs {
        #if os(watchOS)
        Content.WatchOS._makeView(view: view[\.content.watchBody], inputs: inputs)
        #elseif os(visionOS)
        Content.VisionOS._makeView(view: view[\.content.visionBody], inputs: inputs)
        #elseif os(tvOS)
        Content.TvOS._makeView(view: view[\.content.tvBody], inputs: inputs)
        #elseif os(macOS)
        Content.MacOS._makeView(view: view[\.content.macBody], inputs: inputs)
        #else
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            Content.PadOS._makeView(view: view[\.content.padBody], inputs: inputs)
        case .mac:
            Content.MacOS._makeView(view: view[\.content.macBody], inputs: inputs)
        case .phone:
            Content.IOS._makeView(view: view[\.content.phoneBody], inputs: inputs)
        default:
            preconditionFailure("Unsupported")
        }
        #endif
    }
    
    public static func makeViewList(view: _GraphValue<Self>, inputs: _ViewListInputs) -> _ViewListOutputs {
        #if os(watchOS)
        Content.WatchOS._makeViewList(view: view[\.content.watchBody], inputs: inputs)
        #elseif os(visionOS)
        Content.VisionOS._makeViewList(view: view[\.content.visionBody], inputs: inputs)
        #elseif os(tvOS)
        Content.TvOS._makeViewList(view: view[\.content.tvBody], inputs: inputs)
        #elseif os(macOS)
        Content.MacOS._makeViewList(view: view[\.content.macBody], inputs: inputs)
        #else
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            Content.PadOS._makeViewList(view: view[\.content.padBody], inputs: inputs)
        case .mac:
            Content.MacOS._makeViewList(view: view[\.content.macBody], inputs: inputs)
        case .phone:
            Content.IOS._makeViewList(view: view[\.content.phoneBody], inputs: inputs)
        default:
            preconditionFailure("Unsupported")
        }
        #endif
    }

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func viewListCount(inputs: _ViewListCountInputs) -> Int? {
        #if os(watchOS)
        Content.WatchOS._viewListCount(inputs: inputs)
        #elseif os(visionOS)
        Content.VisionOS._viewListCount(inputs: inputs)
        #elseif os(tvOS)
        Content.TvOS._viewListCount(inputs: inputs)
        #elseif os(macOS)
        Content.MacOS._viewListCount(inputs: inputs)
        #else
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            Content.PadOS._viewListCount(inputs: inputs)
        case .mac:
            Content.MacOS._viewListCount(inputs: inputs)
        case .phone:
            Content.IOS._viewListCount(inputs: inputs)
        default:
            preconditionFailure("Unsupported")
        }
        #endif
    }
}
