import SwiftUI

#Preview("Variadic Multi View") {
    let content = ForEach(0..<5) { Text($0, format: .number) }

    ScrollView {
        VariadicViewAdaptor(content, content: { children in
            Text("Header")
            ForEach(children) { child in
                child

                // Adds a divider between child views
                if child.id != children.last?.id {
                    Divider()
                }
            }
            Text("Footer")
        })
        // Applies a red 1px border around each child view
        .border(Color.red)

        VariadicViewAdaptor(content) { child in
            child.background(Color.yellow)
            // Adds a divider between child views
            Divider()
        }
        // Applies a red 1px border around each child view
        .border(Color.red)

        VariadicViewAdaptor(content) { child, offset in
            HStack {
                Text("\(offset + 1).").opacity(0.3).font(.footnote)
                child
            }
            .background(offset.isMultiple(of: 2) ? Color.yellow : .clear)
        }
        // Applies a red 1px border around each child view
        .border(Color.red)
        // Applies default padding around each child view
        .padding()
    }
}

// MARK: - Previews

#Preview("Variadic Unary View") {
    let content = ForEach(0..<5) { Text($0, format: .number) }

    ScrollView {
        VariadicViewAdaptor(unaryView: content, content: { children in
            Text("Header")
            ForEach(children) { child in
                child
                if child.id != children.last?.id {
                    Divider()
                }
            }
            Text("Footer")
        })
        // Shows a 1px red border around the container view
        .border(Color.red)

        VariadicViewAdaptor(unaryView: content) { child in
            child.background(Color.yellow)
            Divider()
        }
        // Shows a 1px red border around the container view
        .border(Color.red)

        VariadicViewAdaptor(unaryView: content) { child, offset in
            HStack {
                Text("\(offset + 1).").opacity(0.3).font(.footnote)
                child
            }
            .background(offset.isMultiple(of: 2) ? Color.yellow : .clear)
        }
        // Shows a 1px red border around the container view
        .border(Color.red)
        // Applies default padding around the container view
        .padding()
    }
}

/// A view capable of exposing its children for manipulation.
struct VariadicViewAdaptor<Root: _VariadicView.ViewRoot, Base: View>: View {
    typealias Children = _VariadicView_Children
    typealias Child = _VariadicView_Children.Element

    let root: Root
    let base: Base

    var body: some View {
        _VariadicView.Tree(root) {
            base
        }
    }
}

// MARK: - VariadicViewUnaryRoot

extension VariadicViewAdaptor {

    @_disfavoredOverload
    init<Content: View>(
        unaryView base: Base,
        @ViewBuilder content: @escaping (_ children: Children) -> Content
    ) where Root == VariadicViewUnaryRoot<Content> {
        self.base = base
        self.root = VariadicViewUnaryRoot(content: content)
    }

    init<Content: View>(
        unaryView base: Base,
        @ViewBuilder forEach content: @escaping (_ child: Child) -> Content
    ) where Root == VariadicViewUnaryRoot<ForEach<Children, Child.ID, Content>> {
        self.base = base
        self.root = VariadicViewUnaryRoot { children in
            ForEach(children, content: content)
        }
    }

    init<Content: View>(
        unaryView base: Base,
        @ViewBuilder forEach content: @escaping (_ child: Child, _ offset: Int) -> Content
    ) where Root == VariadicViewUnaryRoot<ForEach<[(Child, Int)], Child.ID, Content>> {
        self.base = base
        self.root = VariadicViewUnaryRoot { children in
            ForEach(Array(zip(children, children.indices)), id: \.0.id) { child, offset in
                content(child, offset)
            }
        }
    }
}

/// A unary‑root adapter that makes ``VariadicView`` behave like a **single**
/// container (for example, `VStack`, `HStack`, or `Grid`).
///
/// Modifiers that you apply to the resulting `VariadicView` affect **only** the
/// outer container, not the individual subviews.
struct VariadicViewUnaryRoot<Content: View>: _VariadicView.UnaryViewRoot {
    @ViewBuilder var content: (_VariadicView.Children) -> Content

    func body(children: _VariadicView.Children) -> Content {
        content(children)
    }
}

// MARK: - VariadicViewMultiRoot

extension VariadicViewAdaptor {

    @_disfavoredOverload
    init<Content: View>(
        _ base: Base,
        @ViewBuilder content: @escaping (_ children: Children) -> Content
    ) where Root == VariadicViewMultiRoot<Content> {
        self.base = base
        self.root = VariadicViewMultiRoot(content: content)
    }

    init<Content: View>(
        _ base: Base,
        @ViewBuilder forEach content: @escaping (_ child: Child) -> Content
    ) where Root == VariadicViewMultiRoot<ForEach<Children, Child.ID, Content>> {
        self.base = base
        self.root = VariadicViewMultiRoot { children in
            ForEach(children, content: content)
        }
    }

    init<Content: View>(
        _ base: Base,
        @ViewBuilder forEach content: @escaping (_ child: Child, _ offset: Int) -> Content
    ) where Root == VariadicViewMultiRoot<ForEach<[(Child, Int)], Child.ID, Content>> {
        self.base = base
        self.root = VariadicViewMultiRoot { children in
            ForEach(Array(zip(children, children.indices)), id: \.0.id) { child, offset in
                content(child, offset)
            }
        }
    }
}

/// A multi‑root adapter that makes ``VariadicView`` behave like `ForEach` or
/// `Group`.
///
/// Modifiers that you apply to the resulting `VariadicView` are forwarded to
/// **each** subview instead of wrapping the container. For instance, adding a
/// border to a multi‑root variadic view applies the border to every child view.
struct VariadicViewMultiRoot<Content: View>: _VariadicView.MultiViewRoot {
    @ViewBuilder var content: (_VariadicView.Children) -> Content

    func body(children: _VariadicView.Children) -> Content {
        content(children)
    }
}
