//
//  Array.swift
//  JustSmile
//
//  Created by Ivan Kozlov on 03.02.2021.
//

import Foundation

extension Array where Element: FloatingPoint {
    
    var sum: Element {
        reduce(0, +)
    }
    
    var average: Element {
        guard !isEmpty else {
            return 0
        }
        return sum / Element(count)
    }
    
}

extension Array where Element: Hashable {
    var mode: Element? {
        reduce([Element: Int]()) {
            var counts = $0
            counts[$1] = ($0[$1] ?? 0) + 1
            return counts
        }.max { $0.1 < $1.1 }?.0
    }
}
