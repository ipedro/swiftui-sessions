//
//  RadialLayout.swift
//  VariadicViewDemo
//
//  Created by Pedro Almeida on 23.06.25.
//

import SwiftUI

struct RadialView<Content: View>: View {
    private let tree: _VariadicView.Tree<RadialRoot, Content>

    init(@ViewBuilder content: () -> Content) {
        self.tree = .init(RadialRoot(), content: content)
    }

    var body: some View {
        tree
    }
}

private struct RadialRoot: Layout, _VariadicView.UnaryViewRoot {
    func body(children: _VariadicView.Children) -> some View {
        callAsFunction {
            ForEach(children.enumerated().filter({ $0.offset.isMultiple(of: 2) }), id: \.element.id) { _, child in
                child
            }
        }
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        // accept the full proposed space, replacing any nil values with a sensible default
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        // calculate the radius of our bounds
        let radius = min(bounds.size.width, bounds.size.height) / 2

        // figure out the angle between each subview on our circle
        let angle = Angle.degrees(360 / Double(subviews.count)).radians

        for (index, subview) in subviews.enumerated() {
            // ask this view for its ideal size
            let viewSize = subview.sizeThatFits(.unspecified)

            // calculate the X and Y position so this view lies inside our circle's edge
            let xPos = cos(angle * Double(index) - .pi / 2) * (radius - viewSize.width / 2)
            let yPos = sin(angle * Double(index) - .pi / 2) * (radius - viewSize.height / 2)

            // position this view relative to our centre, using its natural size ("unspecified")
            let point = CGPoint(x: bounds.midX + xPos, y: bounds.midY + yPos)
            // if place isn't called views are placed in container center
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}

#Preview {
    let content = ForEach(0..<50) { index in
        Text("\(index)")
    }

    RadialView {
        content
    }

    RadialRoot {
        content
    }
}
