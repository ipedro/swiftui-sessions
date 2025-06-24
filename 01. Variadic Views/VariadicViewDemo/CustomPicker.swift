//
//  CustomPicker.swift
//  VariadicViewDemo
//
//  Created by Pedro Almeida on 24.06.25.
//

import SwiftUI

// A view that mirrors SwiftUI.Picker API
struct CustomPicker<SelectionValue: Hashable, Content: View>: View {
    private let tree: _VariadicView.Tree<CustomPickerRoot<SelectionValue>, Content>

    init(
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content
    ) {
        tree = .init(
            CustomPickerRoot(selection: selection),
            content: content
        )
    }

    var body: some View {
        tree
    }
}

private struct CustomPickerRoot<SelectionValue: Hashable>: _VariadicView.UnaryViewRoot {
    @Binding
    var selection: SelectionValue

    @Namespace
    private var namespace

    func body(children: _VariadicView.Children) -> some View {
        HStack(spacing: .zero) {
            ForEach(children) { child in
                let value = child[ExamplePickerTagKey<SelectionValue>.self]
                let isSelected = value == selection

                Button {
                    if let value {
                        withAnimation(.snappy) {
                            selection = value
                        }
                    }
                } label: {
                    HStack {
                        child
                            .frame(maxWidth: .infinity)
                            .font(.footnote)
                            .fontWeight(isSelected ? .medium : .regular)
                    }
                    .padding(8)
                }
                .foregroundStyle(.primary)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.background)
                            .padding(2)
                            .shadow(color: .black.opacity(0.15), radius: 3)
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }
                }

                if child.id != children.last?.id {
                    Divider()
                }
            }
        }
        .background(.quinary, in: RoundedRectangle(cornerRadius: 8))
        .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Preview Example

fileprivate struct ExamplePickerTagKey<Value>: _ViewTraitKey {
    static var defaultValue: Value? { nil }
}

fileprivate extension View {
    func customPickerTag<V>(_ value: V) -> some View {
        _trait(ExamplePickerTagKey<V>.self, value)
    }
}

#Preview {
    @Previewable @State var selectionA = 2
    @Previewable @State var selectionB = ""

    CustomPicker(selection: $selectionA) {
        ForEach(1..<4) { index in
            Text("Option \(index)")
                .customPickerTag(index)
        }
    }
    .padding()

    Picker("", selection: $selectionB) {
        Text("Option 1").tag("1")
        Text("Option 2").tag("2")
        Text("Option 3").tag("3")
    }
    .pickerStyle(.segmented)
    .padding()
}
