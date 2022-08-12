//
//  Decimal+extension.swift
//  Example
//
//  Created by Vladimir Shutyuk on 12.08.2022.
//

import Foundation

extension Optional where Wrapped == Decimal {
    func isEqualOrBothNil(to decimal: Decimal?) -> Bool {
        if self == nil && decimal == nil {
            return true
        }
        guard let lhs = self, let rhs = decimal else {
            return false
        }
        return lhs.isEqual(to: rhs)
    }
}

extension Decimal {
    func rounded(_ scale: Int = 2,
                 _ roundingMode: NSDecimalNumber.RoundingMode = .bankers) -> Decimal {
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, scale, roundingMode)
        return result
    }
}
