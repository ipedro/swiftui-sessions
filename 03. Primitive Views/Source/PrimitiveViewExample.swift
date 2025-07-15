//
//  PrimitiveViewExample.swift
//  PrimitiveViewDemo
//
//  Created by Pedro Almeida on 02.07.25.
//

import SwiftUI

struct PrimitiveViewExample<Content: View>: View {
    @ViewBuilder var content: Content

    var body: Never {
        fatalError("Body should not be rendered directly")
    }

    nonisolated static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        MainActor.assumeIsolated {
            Content._makeView(view: view[\.content], inputs: inputs)
        }
    }
    
    nonisolated static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        MainActor.assumeIsolated {
            Content._makeViewList(view: view[\.content], inputs: inputs)
        }
    }

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    nonisolated static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        MainActor.assumeIsolated {
            Content._viewListCount(inputs: inputs)
        }
    }
}

#Preview {
    PrimitiveViewExample {
        Text("Test")
        Image(systemName: "star")
    }
}

struct PrimitiveViewExample2: PrimitiveView {
    static func makeView(view: _GraphValue<PrimitiveViewExample2>, inputs: _ViewInputs) -> _ViewOutputs {
        Button<Text>._makeView(view: view[\.button], inputs: inputs)
    }

    static func makeViewList(view: _GraphValue<PrimitiveViewExample2>, inputs: _ViewListInputs) -> _ViewListOutputs {
        Button<Text>._makeViewList(view: view[\.button], inputs: inputs)
    }

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    static func viewListCount(inputs: _ViewListCountInputs) -> Int? {
        Button<Text>._viewListCount(inputs: inputs)
    }

    var button: Button<Text> {
        Button("Some Button", action: {})
    }
}

#Preview {
    PrimitiveViewExample2()
}
