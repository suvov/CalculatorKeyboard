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
        return Decimal(string: value)
    }
}
