import Foundation

enum Expression: Equatable {
    case empty
    case lhs(String)
    case lhsOperator(String, Operator)
    case lhsOperatorRhs(String, Operator, String)
}

extension Expression {
    var value: Decimal? {
        guard case .lhs(let value) = self else {
            return nil
        }
        return Decimal(string: value, locale: Constants.locale)
    }

    static func makeWithValue(_ value: Decimal?) -> Expression {
        if let value = value {
            let scale = Constants.decimalScale
            return .lhs(value.rounded(scale, .bankers).string)
        } else {
            return .empty
        }
    }
}

private extension Decimal {
    var string: String {
        var value = self
        return NSDecimalString(&value, Constants.locale)
    }
}
