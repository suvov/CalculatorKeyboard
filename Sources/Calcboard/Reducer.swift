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
            return reduceWithDecimalSeparator(expression)
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
        case let .lhsOperatorRhs(lhs, opt, rhs):
            return Expression.lhsOperatorRhs(lhs, opt, appendDigit(digit, to: rhs))
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
        case let .lhs(lhs):
            return Expression.lhsOperator(lhs, opt)
        case let .lhsOperator(lhs, _):
            return Expression.lhsOperator(lhs, opt)
        case .lhsOperatorRhs:
            return reduce(evaluate(expression), with: opt)
        }
        return expression
    }
}

// MARK: - Decimal separator

private extension Reducer {
    func reduceWithDecimalSeparator(_ expression: Expression) -> Expression {
        switch expression {
        case .empty, .lhsOperator:
            break
        case let .lhs(lhs):
            return Expression.lhs(appendSeparator(to: lhs))
        case let .lhsOperatorRhs(lhs, opt, rhs):
            return Expression.lhsOperatorRhs(lhs, opt, appendSeparator(to: rhs))
        }
        return expression
    }
    
    func appendSeparator(to string: String) -> String {
        let new = string + Constants.decimalSeparator
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
        case let .lhs(lhs):
            let newLhs = String(lhs.dropLast())
            if newLhs.isEmpty {
                return Expression.empty
            } else {
                return Expression.lhs(newLhs)
            }
        case let .lhsOperator(lhs, _):
            return Expression.lhs(lhs)
        case let .lhsOperatorRhs(lhs, opt, rhs):
            let newRhs = String(rhs.dropLast())
            if newRhs.isEmpty {
                return Expression.lhsOperator(lhs, opt)
            } else {
                return Expression.lhsOperatorRhs(lhs, opt, newRhs)
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
