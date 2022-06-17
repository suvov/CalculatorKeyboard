import Foundation

struct Evaluator {
    private let scale: Int

    init(scale: Int = 2) {
        self.scale = scale
    }

    func evaluate(_ expression: Expression) -> String? {
        switch expression {
        case .lhsOperatorRhs(let lhs, let opt, let rhs):
            return evaluate(lhs: lhs, rhs: rhs, opt: opt)
        default:
            return nil
        }
    }
}

private extension Evaluator {
    func evaluate(lhs: String, rhs: String, opt: Operator) -> String? {
        guard let lhsDecimal = Decimal(string: lhs),
              let rhsDecimal = Decimal(string: rhs)
        else {
            return nil
        }
        var result: Decimal?
        switch opt {
        case .addition:
            result = (lhsDecimal + rhsDecimal).rounded(scale, .bankers)
        case .subtraction:
            result = (lhsDecimal - rhsDecimal).rounded(scale, .bankers)
        case .multiplication:
            result = (lhsDecimal * rhsDecimal).rounded(scale, .bankers)
        case .division:
            result = (lhsDecimal / rhsDecimal).rounded(scale, .bankers)
        }
        if let result = result, result != Decimal.nan {
            return result.description
        }
        return nil
    }
}
