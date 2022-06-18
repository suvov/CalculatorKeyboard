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
            return reduce(expression, with: opt)
        case .decimalSeparator:
            return reduce(expression, with: ".")
        case .equals:
            return evaluate(expression)
        case .backspace:
            return reduceWithBackspace(expression)
        }
    }
}

// MARK: - Digits

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

// MARK: - Operators

private extension Reducer {
    func reduce(_ expression: Expression, with opt: Operator) -> Expression {
        switch expression {
        case .empty:
            break
        case let .lhs(lhsString):
            return Expression.lhsOperator(lhsString, opt)
        case let .lhsOperator(lhsString, _):
            return Expression.lhsOperator(lhsString, opt)
        case .lhsOperatorRhs:
            return reduce(evaluate(expression), with: opt)
        }
        return expression
    }
}

// MARK: - Decimal separator

private extension Reducer {
    func reduce(_ expression: Expression, with separator: String) -> Expression {
        switch expression {
        case .empty, .lhsOperator:
            break
        case let .lhs(lhsString):
            return Expression.lhs(appendSeparator(separator, to: lhsString))
        case let .lhsOperatorRhs(lhsString, opt, rhsString):
            return Expression.lhsOperatorRhs(lhsString, opt, appendSeparator(separator, to: rhsString))
        }
        return expression
    }
    
    func appendSeparator(_ separator: String, to string: String) -> String {
        let new = string + separator
        if validator.isValidPartialDecimalString(new) {
            return new
        }
        return string
    }
}

// MARK: - Backspace

private extension Reducer {
    func reduceWithBackspace(_ expression: Expression) -> Expression {
        switch expression {
        case .empty:
            break
        case let .lhs(lhsString):
            let newLhs = String(lhsString.dropLast())
            if newLhs.isEmpty {
                return Expression.empty
            } else {
                return Expression.lhs(newLhs)
            }
        case let .lhsOperator(lhsString, _):
            return Expression.lhs(lhsString)
        case let .lhsOperatorRhs(lhsString, opt, rhsString):
            let newRhs = String(rhsString.dropLast())
            if newRhs.isEmpty {
                return Expression.lhsOperator(lhsString, opt)
            } else {
                return Expression.lhsOperatorRhs(lhsString, opt, newRhs)
            }
        }
        return expression
    }
}

// MARK: - Evaluate

private extension Reducer {
    func evaluate(_ expression: Expression) -> Expression {
        switch expression {
        case .lhsOperatorRhs:
            if let decimalString = evaluator.evaluate(expression), validator.isValidDecimalString(decimalString) {
                return Expression.lhs(decimalString)
            } else {
                return .empty
            }
        default:
            return expression
        }
    }
}
