import XCTest
@testable import CalculatorKeyboard

final class ExpressionTests: XCTestCase {
    
    func testReturnsNilValue() {
        XCTAssertNil(Expression.empty.value)
        XCTAssertNil(Expression.lhs("").value)
        XCTAssertNil(Expression.lhsOperator("1", .addition).value)
        XCTAssertNil(Expression.lhsOperatorRhs("1", .addition, "2").value)
    }
    
    func testReturnsValue() {
        XCTAssertNotNil(Expression.lhs("0.99").value)
    }
}
