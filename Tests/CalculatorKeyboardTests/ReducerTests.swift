import XCTest
@testable import CalculatorKeyboard

class ReducerTests: XCTestCase {

    private let reducer = Reducer(validator: Validator(), evaluator: Evaluator())

    // MARK: - Append digit

    // "" -> "1"
    func testAppendsDigitToEmpty() {
        let expression = Expression.empty
        XCTAssertEqual(reducer.reduce(expression, with: .digit(.one)),
                       Expression.lhs("1"))
    }
    
    // "1" -> "10"
    func testAppendsDigitToLhs() {
        let expression = Expression.lhs("1")
        XCTAssertEqual(reducer.reduce(expression, with: .digit(.zero)),
                       Expression.lhs("10"))
    }
    
    // "10 +" -> "10 + 9"
    func testAppendsDigitToLhsOperator() {
        let expression = Expression.lhsOperator("10", .addition)
        XCTAssertEqual(reducer.reduce(expression, with: .digit(.nine)),
                       Expression.lhsOperatorRhs("10", .addition, "9"))
    }
    
    // "10 × 9" -> "10 × 95"
    func testAppendsDigitToLhsOperatorRhs() {
        let expression = Expression.lhsOperatorRhs("10", .multiplication, "9")
        XCTAssertEqual(reducer.reduce(expression, with: .digit(.five)),
                       Expression.lhsOperatorRhs("10", .multiplication, "95"))
    }
    
    // "0" -> "2"
    func testReplacesZeroWithDigitLhs() {
        let expression = Expression.lhs("0")
        XCTAssertEqual(reducer.reduce(expression, with: .digit(.two)),
                       Expression.lhs("2"))
    }
    
    // "10" + "0" -> "10" + "8"
    func testReplacesZeroWithDigitLhsOperatorRhs() {
        let expression = Expression.lhsOperatorRhs("10", .subtraction, "0")
        XCTAssertEqual(reducer.reduce(expression, with: .digit(.eight)),
                       Expression.lhsOperatorRhs("10", .subtraction, "8"))
    }
    
    // MARK: - Append operator
    
    // "" + "÷" -> ""
    func testAppendingOperatorToEmpty() {
        let expression = Expression.empty
        XCTAssertEqual(reducer.reduce(expression, with: .arithmeticOperator(.division)),
                       Expression.empty)

    }
    
    // "1" + "-" -> "1 -"
    func testAppendingOperatorToLhsCaseOne() {
        let expression = Expression.lhs("1")
        XCTAssertEqual(reducer.reduce(expression, with: .arithmeticOperator(.subtraction)),
                       Expression.lhsOperator("1", .subtraction))
    }
    
    // "1 -" + "-" -> "1 -"
    func testAppendingOperatorToLhsCaseTwo() {
        let expression = Expression.lhsOperator("1", .subtraction)
        XCTAssertEqual(reducer.reduce(expression, with: .arithmeticOperator(.subtraction)),
                       Expression.lhsOperator("1", .subtraction))
        
    }
    
    // "1 -" + "×" -> "1 ×"
    func testChangesOperator() {
        let expression = Expression.lhsOperator("1", .subtraction)
        XCTAssertEqual(reducer.reduce(expression, with: .arithmeticOperator(.multiplication)),
                       Expression.lhsOperator("1", .multiplication))
        
    }
    
    // "1 + 3" + "×" -> "4 ×"
    func testEvaluatesAfterAppendingOperator() {
        let expression = Expression.lhsOperatorRhs("1", .addition, "3")
        XCTAssertEqual(reducer.reduce(expression, with: .arithmeticOperator(.multiplication)),
                       Expression.lhsOperator("4", .multiplication))
    }
    
    // MARK: - Append decimal separator
    
    // "" + "." -> ""
    func testAppendingSeparatorToEmpty() {
        let expression = Expression.empty
        XCTAssertEqual(reducer.reduce(expression, with: .decimalSeparator),
                       Expression.empty)
    }
    
    // "1 + " + "." -> ""
    func testAppendingSeparatorToLhsOperator() {
        let expression = Expression.lhsOperator("1", .addition)
        XCTAssertEqual(reducer.reduce(expression, with: .decimalSeparator), expression)
    }
    
    // "0" + "." -> "0."
    func testAppendingSeparatorToLhsCase1() {
        let expression = Expression.lhs("0")
        XCTAssertEqual(reducer.reduce(expression, with: .decimalSeparator),
                       Expression.lhs("0."))
    }
    
    // "0." + "." -> "0."
    func testAppendingSeparatorToLhsCase2() {
        let expression = Expression.lhs("0.")
        XCTAssertEqual(reducer.reduce(expression, with: .decimalSeparator), expression)
    }
    
    // "1 + 1" + "." -> "1 + 1."
    func testAppendingSeparatorToLhsOperatorRhsCase1() {
        let expression = Expression.lhsOperatorRhs("1", .addition, "1")
        XCTAssertEqual(reducer.reduce(expression, with: .decimalSeparator),
                       Expression.lhsOperatorRhs("1", .addition, "1."))
    }
    
    // "1 + 1." + "." -> "1 + 1."
    func testAppendingSeparatorToLhsOperatorRhsCase2() {
        let expression = Expression.lhsOperatorRhs("1", .addition, "1.")
        XCTAssertEqual(reducer.reduce(expression, with: .decimalSeparator), expression)
    }
    
    // "1.99 + 0" + "." -> "1.99 + 0."
    func testAppendingSeparatorToLhsOperatorRhsCase3() {
        let expression = Expression.lhsOperatorRhs("1.99", .addition, "0")
        XCTAssertEqual(reducer.reduce(expression, with: .decimalSeparator),
                       Expression.lhsOperatorRhs("1.99", .addition, "0."))
    }
    
    // MARK: - Evaluate
    
    // "1 + 3" -> "4"
    func testEvaluateLhsOperatorRhs() {
        let expression = Expression.lhsOperatorRhs("1", .addition, "3")
        XCTAssertEqual(reducer.reduce(expression, with: .equals),
                       Expression.lhs("4"))
    }
    
    // "1"
    func testEvaluateLhs() {
        let expression = Expression.lhs("1")
        XCTAssertEqual(reducer.reduce(expression, with: .equals), expression)
    }
    
    // "1 -"
    func testEvaluateLhsOperator() {
        let expression = Expression.lhsOperator("1", .subtraction)
        XCTAssertEqual(reducer.reduce(expression, with: .equals), expression)
    }
    
    // MARK: - Backspace
    
    // "12" + "􁂈" -> "1"
    func testDropsLastOnLhsCase1() {
        let expression = Expression.lhs("12")
        XCTAssertEqual(reducer.reduce(expression, with: .backspace),
                       Expression.lhs("1"))
    }
    
    // "1" + "􁂈" -> ""
    func testDropsLastOnLhsCase2() {
        let expression = Expression.lhs("1")
        XCTAssertEqual(reducer.reduce(expression, with: .backspace),
                       Expression.empty)
    }
    
    // "1 ×" + "􁂈" -> "1"
    func testDropsLastOnLhsOperator() {
        let expression = Expression.lhsOperator("1", .multiplication)
        XCTAssertEqual(reducer.reduce(expression, with: .backspace),
                       Expression.lhs("1"))
    }
    
    // "3 × 10" + "􁂈" -> "3 × 1"
    func testDropsLastOnLhsOperatorRhsCase1() {
        let expression = Expression.lhsOperatorRhs("3", .multiplication, "10")
        XCTAssertEqual(reducer.reduce(expression, with: .backspace),
                       Expression.lhsOperatorRhs("3", .multiplication, "1"))
    }
    
    // "3 × 1" + "􁂈" -> "3 ×"
    func testDropsLastOnLhsOperatorRhsCase2() {
        let expression = Expression.lhsOperatorRhs("3", .multiplication, "1")
        XCTAssertEqual(reducer.reduce(expression, with: .backspace),
                       Expression.lhsOperator("3", .multiplication))
    }
}
