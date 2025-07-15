//
//  PrimitiveView.swift
//  PrimitiveViewDemo
//
//  Created by Pedro Almeida on 27.06.25.
//

import SwiftUI

@MainActor
public protocol PrimitiveView: View where Body == Never {
    @preconcurrency static func makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs

    @preconcurrency static func makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @preconcurrency static func viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int?
}

public extension PrimitiveView {
    var body: Never {
        fatalError("Primitive views cannot be used directly")
    }

    nonisolated static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        MainActor.assumeIsolated {
            Self.makeView(view: view, inputs: inputs)
        }
    }

    nonisolated static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        MainActor.assumeIsolated {
            Self.makeViewList(view: view, inputs: inputs)
        }
    }

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    nonisolated static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        MainActor.assumeIsolated {
            Self.viewListCount(inputs: inputs)
        }
    }
}
