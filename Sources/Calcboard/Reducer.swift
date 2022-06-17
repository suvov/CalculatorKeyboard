import Foundation

struct Reducer {
    private let validator: Validator
    private let evaluator: Evaluator
    
    init(validator: Validator, evaluator: Evaluator) {
        self.validator = validator
        self.evaluator = evaluator
    }

    func reduce(_ expression: Expression, with input: Input) -> Expression {
        switch input {
        case let .digit(digit):
            return reduce(expression, with: digit)
        case let .arithmeticOperator(opt):
            return expression
        case .decimalSeparator:
            return expression
        case .equals:
            return expression
        case .backspace:
            return expression
        }
    }
}

private extension Reducer {
    func reduce(_ expression: Expression, with digit: Digit) -> Expression {
        switch expression {
        case .empty:
            return Expression.lhs(appendDigit(digit, to: ""))
        case let .lhs(string):
            return Expression.lhs(appendDigit(digit, to: string))
        case let .lhsOperator(string, opt):
            return Expression.lhsOperatorRhs(string, opt, appendDigit(digit, to: ""))
        case let .lhsOperatorRhs(lhsString, opt, rhsString):
            return Expression.lhsOperatorRhs(lhsString, opt, appendDigit(digit, to: rhsString))
        }
    }
    
    func appendDigit(_ digit: Digit, to string: String) -> String {
        let digit = digit.rawValue
        let new: String
        if string == "0" && digit > 0 {
            new = "\(digit)"
        } else {
            new = string + "\(digit)"
        }
        if validator.isValidPartialDecimalString(new) {
            return new
        }
        return string
    }
}
