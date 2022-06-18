import XCTest
@testable import Calcboard

final class EvaluatorTests: XCTestCase {
    
    private let evaluator = Evaluator()
    
    func testDivizionByZero() {
        let expression = Expression.lhsOperatorRhs("1", .division, "0")
        XCTAssertNil(evaluator.evaluate(expression))
    }
    
    func testAddition() {
        let expression = Expression.lhsOperatorRhs("1.22", .addition, "1.88")
        XCTAssertEqual(evaluator.evaluate(expression), "3.1")
    }
    
    func testSutraction() {
        let expression = Expression.lhsOperatorRhs("3.11", .subtraction, "2.11")
        XCTAssertEqual(evaluator.evaluate(expression), "1")
    }
    
    func testDivision() {
        let expression = Expression.lhsOperatorRhs("3.33", .division, "3")
        XCTAssertEqual(evaluator.evaluate(expression), "1.11")
    }
    
    func testMultiplication() {
        let expression = Expression.lhsOperatorRhs("1.11", .multiplication, "3.0")
        XCTAssertEqual(evaluator.evaluate(expression), "3.33")
    }
}
