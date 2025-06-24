//
//  CustomList.swift
//  VariadicViewDemo
//
//  Created by Pedro Almeida on 23.06.25.
//

import SwiftUI

struct CustomList<Content: View>: View {
    private let tree: _VariadicView.Tree<CustomListRoot, Content>

    init(@ViewBuilder content: () -> Content) {
        self.tree = .init(CustomListRoot(), content: content)
    }

    var body: some View {
        tree
    }
}

private struct CustomListRoot: _VariadicView.UnaryViewRoot {
    func body(children: _VariadicView.Children) -> some View {
        GroupBox {
            ForEach(children.reversed()) { child in
                HStack {
                    child
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .safeAreaInset(edge: .bottom) {
                    if child.id != children.first?.id {
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview {
    CustomList {
        Text("Abc")
        Text("Def")
        Text("Ghi")
    }
    .padding()
}
