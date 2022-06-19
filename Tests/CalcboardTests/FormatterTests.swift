import XCTest
@testable import Calcboard

final class FormatterTests: XCTestCase {
    
    private let formatterWithDotDecimal = Formatter(locale: Locale(identifier: "en_US"))
    private let formatterWithCommaDecimal = Formatter(locale: Locale(identifier: "fr_FR"))

    func testEmpty() {
        let expression = Expression.empty
        XCTAssertEqual(formatterWithDotDecimal.string(from: expression), "")
        XCTAssertEqual(formatterWithCommaDecimal.string(from: expression), "")
    }
    
    func testLhs() {
        let expression = Expression.lhs("1.01")
        XCTAssertEqual(formatterWithDotDecimal.string(from: expression), "1.01")
        XCTAssertEqual(formatterWithCommaDecimal.string(from: expression), "1,01")
    }
    
    func testLhsOperator() {
        let expression = Expression.lhsOperator("9.1", .addition)
        XCTAssertEqual(formatterWithDotDecimal.string(from: expression), "9.1 + ")
        XCTAssertEqual(formatterWithCommaDecimal.string(from: expression), "9,1 + ")
    }
    
    func testLhsOperatorRhs() {
        let expression = Expression.lhsOperatorRhs("1.11", .addition, "0.89")
        XCTAssertEqual(formatterWithDotDecimal.string(from: expression), "1.11 + 0.89")
        XCTAssertEqual(formatterWithCommaDecimal.string(from: expression), "1,11 + 0,89")
    }
    
    func testOneZeroAfterSeparator() {
        let expression = Expression.lhs("1.0")
        XCTAssertEqual(formatterWithDotDecimal.string(from: expression), "1.0")
        XCTAssertEqual(formatterWithCommaDecimal.string(from: expression), "1,0")
    }
    
    func testTwoZeroesAfterSeparator() {
        let expression = Expression.lhs("1.00")
        XCTAssertEqual(formatterWithDotDecimal.string(from: expression), "1.00")
        XCTAssertEqual(formatterWithCommaDecimal.string(from: expression), "1,00")
    }
}
