import Foundation

enum Expression {
    case empty
    case lhs(String)
    case lhsOperator(String, Operator)
    case lhsOperatorRhs(String, Operator, String)
}

extension Expression {
    var value: Decimal? {
        nil
    }
}
