import SwiftUI

/// A view capable of exposing its children for manipulation.
///
/// ## Multi-root Behavior (Default)
///
/// Modifiers applied to the variadic view get applied to each subview, like `ForEach` or `Group`.
///
/// ### Example
///
/// The example below inserts dividers between subviews.
///
/// ```swift
/// let texts = ForEach(0..<5) {
///     Text($0, format: .number)
/// }
///
/// VStack {
///     Text("Header")
///
///     VariadicView(texts) { child in
///         child
///         // Applies a divider between texts
///         if child.id != children.last?.id {
///             Divider()
///         }
///     }
///     // Applies a red 1px border around each text
///     .border(Color.red)
///
///     Text("Footer")
/// }
/// ```
///
/// ### Initializers
///
/// - ``VariadicView/init(_:forEach:)-1xxuo``
/// - ``VariadicView/init(_:forEach:)-5isct``.
/// - ``VariadicView/init(_:content:)``
///
/// - SeeAlso: ``VariadicViewMultiRoot``.
///
/// ## Unary-root Behavior
///
/// Modifiers applied to the variadic view get applied to the container, like `VStack`, `ZStack` or `List`.
///
/// ### Example
///
/// The example below inserts dividers between child views.
///
/// ```swift
/// let texts = ForEach(0..<5) {
///     Text($0, format: .number)
/// }
///
/// VStack {
///     Text("Header")
///
///     VariadicView(unaryView: texts) { child in
///         child
///         // Applies a divider between texts
///         if child.id != children.last?.id {
///             Divider()
///         }
///     }
///     // Applies a red 1px border around the container view
///     .border(Color.red)
///
///     Text("Footer")
/// }
/// ```
///
/// ### Initializers
///
/// - ``VariadicView/init(unaryView:forEach:)-5a4cv``
/// - ``VariadicView/init(unaryView:forEach:)-5ajl9``.
/// - ``VariadicView/init(unaryView:content:)``
///
/// - SeeAlso: ``VariadicViewUnaryRoot``.
///
/// > Tip: `VariadicView` doesn't enforce its own layout, for that you can wrap it in containers like `HStack`, `VStack`, `Grid`, custom layouts and so on.
public struct VariadicView<Root: _VariadicView.ViewRoot, Base: View>: View {
    /// An ad hoc collection of the children of a variadic view.
    ///
    /// > Tip: Conforms to `View`, `RandomAccessCollection` and `BidirectionalCollection`.
    public typealias Children = _VariadicView_Children

    /// A child of a variadic view.
    ///
    /// > Tip: Conforms to `View`, `Identifiable` and can read ``ViewTraitKey`` values via subscript.
    public typealias Child = _VariadicView_Children.Element

    /// A type of root that creates a View when its result builder is invoked with View.
    let root: Root

    /// A content subtree.
    let base: Base

    public var body: some View {
        _VariadicView.Tree(root) {
            base
        }
    }
}

public extension View {
    /// Destructures the view by iterating over each child.
    @inlinable func forEach<V>(
        @ViewBuilder content: @escaping (_ child: VariadicView.Child) -> V
    ) -> some View where V: View {
        VariadicView(self, forEach: content)
    }

    /// Destructures the view by enumerating each child.
    @inlinable func forEach<V>(
        @ViewBuilder content: @escaping (_ child: VariadicView.Child, _ offset: Int) -> V
    ) -> some View where V: View {
        VariadicView(self, forEach: content)
    }
}

// MARK: - VariadicViewUnaryRoot

public extension VariadicView {
    /// Creates a unary‑root ``VariadicView``.
    ///
    /// The resulting view behaves like a single container (for example, `VStack`,
    /// `HStack`, or `Grid`). Any modifiers you apply to the `VariadicView` affect
    /// the container as a whole, **not** each individual child.
    ///
    /// Use this overload when you want the `content` closure to receive the entire
    /// collection of `children` at once so that you can build a custom hierarchy
    /// from them.
    ///
    /// - Parameters:
    ///   - base: A view that supplies the underlying collection of children.
    ///   - content: A closure that takes the exposed `children`
    ///     collection and returns the resulting view hierarchy.
    @_disfavoredOverload
    init<Content: View>(
        unaryView base: Base,
        @ViewBuilder content: @escaping (_ children: Children) -> Content
    ) where Root == VariadicViewUnaryRoot<Content> {
        self.base = base
        self.root = VariadicViewUnaryRoot(content: content)
    }

    /// Creates a unary‑root ``VariadicView`` whose body is produced by iterating
    /// over each child.
    ///
    /// The closure receives each `child` individually, letting you customize the
    /// view for that specific element while the variadic view continues to behave
    /// as a single container.
    ///
    /// - Parameters:
    ///   - base: A view that supplies the underlying collection of children.
    ///   - content: A closure that takes an individual `child`
    ///     and returns a view.
    init<Content: View>(
        unaryView base: Base,
        @ViewBuilder forEach content: @escaping (_ child: Child) -> Content
    ) where Root == VariadicViewUnaryRoot<ForEach<Children, Child.ID, Content>> {
        self.base = base
        self.root = VariadicViewUnaryRoot { children in
            ForEach(children, content: content)
        }
    }

    /// Creates a unary‑root ``VariadicView`` that also provides each child’s
    /// zero‑based position.
    ///
    /// Use this overload when you need the index (`offset`) of a child to apply
    /// alternating row styles, display numbers, or perform other position‑based
    /// logic.
    ///
    /// - Parameters:
    ///   - base: A view that supplies the underlying collection of children.
    ///   - content: A closure that receives a `child` together
    ///     with its `offset` in the sequence and returns a view.
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
public struct VariadicViewUnaryRoot<Content: View>: _VariadicView.UnaryViewRoot {
    @ViewBuilder var content: (_VariadicView.Children) -> Content

    public func body(children: _VariadicView.Children) -> Content {
        content(children)
    }
}

// MARK: - VariadicViewMultiRoot

public extension VariadicView {
    /// Creates a multi‑root ``VariadicView``.
    ///
    /// A multi‑root variadic view behaves like `ForEach` or `Group`. Any modifiers
    /// you apply to the `VariadicView` are forwarded to **each** child instead of
    /// wrapping the container.
    ///
    /// - Parameters:
    ///   - base: A view that supplies the underlying collection of children.
    ///   - content: A closure that receives the full `children`
    ///     collection and returns the resulting view hierarchy.
    @_disfavoredOverload
    init<Content: View>(
        _ base: Base,
        @ViewBuilder content: @escaping (_ children: Children) -> Content
    ) where Root == VariadicViewMultiRoot<Content> {
        self.base = base
        self.root = VariadicViewMultiRoot(content: content)
    }

    /// Creates a multi‑root ``VariadicView`` whose body is built by iterating over
    /// each child.
    ///
    /// - Parameters:
    ///   - base: A view that supplies the underlying collection of children.
    ///   - content: A closure that takes an individual `child`
    ///     and returns a view.
    ///
    /// - Note: Because the result is multi‑root, any modifiers you apply to the
    ///   `VariadicView` are applied to **each** resulting child.
    init<Content: View>(
        _ base: Base,
        @ViewBuilder forEach content: @escaping (_ child: Child) -> Content
    ) where Root == VariadicViewMultiRoot<ForEach<Children, Child.ID, Content>> {
        self.base = base
        self.root = VariadicViewMultiRoot { children in
            ForEach(children, content: content)
        }
    }

    /// Creates a multi‑root ``VariadicView`` that supplies both the `child` and
    /// its position in the sequence.
    ///
    /// - Parameters:
    ///   - base: A view that supplies the underlying collection of children.
    ///   - content: A closure that receives a `child` along with
    ///     its zero‑based `offset` and returns a view.
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
public struct VariadicViewMultiRoot<Content: View>: _VariadicView.MultiViewRoot {
    @ViewBuilder var content: (_VariadicView.Children) -> Content

    public func body(children: _VariadicView.Children) -> Content {
        content(children)
    }
}

#Preview("Variadic Multi View") {
    let content = ForEach(0..<5) { Text($0, format: .number) }

    ScrollView {
        VariadicView(content, content: { children in
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

        VariadicView(content) { child in
            child.background(Color.yellow)
            // Adds a divider between child views
            Divider()
        }
        // Applies a red 1px border around each child view
        .border(Color.red)

        VariadicView(content) { child, offset in
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
        VariadicView(unaryView: content, content: { children in
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

        VariadicView(unaryView: content) { child in
            child.background(Color.yellow)
            Divider()
        }
        // Shows a 1px red border around the container view
        .border(Color.red)

        VariadicView(unaryView: content) { child, offset in
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
