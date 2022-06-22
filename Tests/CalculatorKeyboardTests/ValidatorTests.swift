import XCTest
@testable import CalculatorKeyboard

class ValidatorTests: XCTestCase {

    private let validator = Validator()

    func testValidatesPartialDecimal() {
        XCTAssertFalse(validator.isValidPartialDecimalString(""))

        XCTAssertFalse(validator.isValidPartialDecimalString("."))
        XCTAssertFalse(validator.isValidPartialDecimalString("00"))
        XCTAssertFalse(validator.isValidPartialDecimalString("0.."))
        XCTAssertFalse(validator.isValidPartialDecimalString("0.111"))

        XCTAssertFalse(validator.isValidPartialDecimalString("-1"))

        XCTAssertTrue(validator.isValidPartialDecimalString("0."))
        XCTAssertTrue(validator.isValidPartialDecimalString("2."))
        XCTAssertTrue(validator.isValidPartialDecimalString("99995."))
        XCTAssertTrue(validator.isValidPartialDecimalString("100."))
        XCTAssertTrue(validator.isValidPartialDecimalString("111"))
    }

    func testValidatesDecimal() {
        XCTAssertFalse(validator.isValidDecimalString(""))
        XCTAssertFalse(validator.isValidDecimalString("."))
        XCTAssertFalse(validator.isValidDecimalString("00"))
        XCTAssertFalse(validator.isValidDecimalString("0.."))
        XCTAssertFalse(validator.isValidDecimalString("0.111"))

        XCTAssertFalse(validator.isValidPartialDecimalString("-9.99"))

        XCTAssertTrue(validator.isValidDecimalString("0.1"))
        XCTAssertTrue(validator.isValidDecimalString("2.1"))
        XCTAssertTrue(validator.isValidDecimalString("99995.32"))
        XCTAssertTrue(validator.isValidDecimalString("100.99"))
        XCTAssertTrue(validator.isValidDecimalString("111"))
    }
}
