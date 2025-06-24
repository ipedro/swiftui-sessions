//
//  Models.swift
//  CombineSelectiveUpdatesDemo
//
//  Created by Pedro Almeida on 17.06.25.
//

import Foundation

enum Icon: String, CaseIterable {
    case arrowShapeDown = "arrow.down"
    case arrowShapeLeft = "arrow.left"
    case arrowShapeRight = "arrow.right"
    case arrowShapeUp = "arrow.up"
    case arrowtriangleDown = "arrowtriangle.down"
    case arrowtriangleLeft = "arrowtriangle.left"
    case arrowtriangleRight = "arrowtriangle.right"
    case arrowtriangleUp = "arrowtriangle.up"
    case globe
    case minus
    case plus
    case square
}

struct ListItem: Equatable, Identifiable, CustomStringConvertible {
    let id: UUID = UUID()
    var description: String
    var icon: Icon
}

extension Array where Element == ListItem {
    mutating func appendItem() {
        append(
            ListItem(
                description: "Item \(count)",
                icon: Icon.allCases.randomElement()!
            )
        )
    }
}
