import XCTest
@testable import Calcboard

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
}
