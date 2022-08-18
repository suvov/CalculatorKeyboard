import Combine
import XCTest
@testable import CalculatorKeyboard

class TransformerTests: XCTestCase {

    private var subscriptions: Set<AnyCancellable>!
    private typealias Output = (String, Decimal?)

    private let transformer = Transformer(
        reducer: Reducer(validator: Validator(),
                         evaluator: Evaluator()),
        formatter: Formatter(validator: Validator()),
        setDecimalThrottle: 0.1
    )

    override func setUp() {
        super.setUp()
        subscriptions = []
    }

    func testLhsCase1() {
        let inputs: [CalculatorInput] = [.digit(.one)]
        let expected: Output = (text: "1", decimalValue: Decimal(string: "1")!)
        testTransformsKeyboardInputs(inputs, into: expected)
    }

    func testLhsCase2() {
        let inputs: [CalculatorInput] = [.digit(.one),
                              .decimalSeparator,
                              .digit(.zero),
                              .digit(.one)]
        let expected: Output = (text: "1.01", decimalValue: Decimal(string: "1.01"))
        testTransformsKeyboardInputs(inputs, into: expected)
    }

    func testLhsCase3() {
        let inputs: [CalculatorInput] = [.digit(.one),
                              .decimalSeparator,
                              .digit(.one)]
        let expected: Output = (text: "1.1", decimalValue: Decimal(string: "1.1"))
        testTransformsKeyboardInputs(inputs, into: expected)
    }

    func testLhsCase4() {
        let inputs: [CalculatorInput] = [.digit(.one),
                              .decimalSeparator,
                              .digit(.one),
                              .digit(.zero)]
        let expected: Output = (text: "1.1", decimalValue: Decimal(string: "1.1"))
        testTransformsKeyboardInputs(inputs, into: expected)
    }

    func testLhsOperator() {
        let inputs: [CalculatorInput] = [.digit(.nine),
                               .decimalSeparator,
                               .digit(.two),
                               .arithmeticOperator(.addition)]
        let expected: Output = (text: "9.2 + ", decimalValue: nil)
        testTransformsKeyboardInputs(inputs, into: expected)
    }

    func testLhsOperatorRhs() {
        let inputs: [CalculatorInput] = [.digit(.three),
                               .decimalSeparator,
                               .digit(.two),
                               .arithmeticOperator(.addition),
                               .digit(.four),
                               .decimalSeparator,
                               .digit(.eight)]
        let expected: Output = (text: "3.2 + 4.8", decimalValue: nil)
        testTransformsKeyboardInputs(inputs, into: expected)
    }

    func testCalculates() {
        let inputs: [CalculatorInput] = [.digit(.three),
                               .decimalSeparator,
                               .digit(.two),
                               .arithmeticOperator(.addition),
                               .digit(.four),
                               .decimalSeparator,
                               .digit(.eight),
                               .equals]
        let expected: Output = (text: "8", decimalValue: Decimal(string: "8"))
        testTransformsKeyboardInputs(inputs, into: expected)
    }

    func testSetsDecimalValueEmpty() {
        let inputs: [CalculatorInput] = []
        let decimal = Decimal(string: "8")
        testSetsDecimalValue(keyboardInputs: inputs, decimal: decimal, into: "8")
    }

    func testSetsDecimalValueLhs() {
        let inputs: [CalculatorInput] = [.digit(.three),
                                       .decimalSeparator,
                                       .digit(.two)]
        let decimal = Decimal(string: "8")
        testSetsDecimalValue(keyboardInputs: inputs, decimal: decimal, into: "8")
    }

    func testSetsDecimalValueLhsOperator() {
        let inputs: [CalculatorInput] = [.digit(.three),
                                       .decimalSeparator,
                                       .digit(.two),
                                       .arithmeticOperator(.addition)]
        let decimal = Decimal(string: "8")
        testSetsDecimalValue(keyboardInputs: inputs, decimal: decimal, into:  "8")
    }

    func testSetsDecimalValueLhsOperatorRhs() {
        let inputs: [CalculatorInput] = [.digit(.three),
                                       .decimalSeparator,
                                       .digit(.two),
                                       .arithmeticOperator(.addition),
                                       .digit(.four),
                                       .decimalSeparator,
                                       .digit(.eight)]
        let decimal = Decimal(string: "8")
        testSetsDecimalValue(keyboardInputs: inputs, decimal: decimal, into: "8")
    }

    func testSetsDecimalValueNil() {
        let inputs: [CalculatorInput] = [.digit(.three),
                                       .decimalSeparator,
                                       .digit(.two)]
        testSetsDecimalValue(keyboardInputs: inputs, decimal: nil, into: "")
    }
}

private extension TransformerTests {
    func testTransformsKeyboardInputs(_ keyboardInputs: [CalculatorInput],
                                      into expected: (String, Decimal?)) {
        let calculatorSubject = PassthroughSubject<CalculatorInput, Never>()
        let decimalSubject = Empty<Decimal?, Never>()

        let transformerInput = Transformer.Input(
            calculator: calculatorSubject.eraseToAnyPublisher(),
            decimalValue: decimalSubject.eraseToAnyPublisher()
        )
        let output = transformer.transform(input: transformerInput)

        var received: Output?
        let expectation = self.expectation(description: "Output")
        var count = keyboardInputs.count

        Publishers.CombineLatest(output.text, output.decimalValue)
            .sink {
                received = $0
                count -= 1
                if count == 0 {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        for input in keyboardInputs {
            calculatorSubject.send(input)
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(received?.0, expected.0)
        XCTAssertEqual(received?.1, expected.1)
    }

    func testSetsDecimalValue(keyboardInputs: [CalculatorInput],
                              decimal: Decimal?,
                              into expected: String) {
        let calculatorSubject = PassthroughSubject<CalculatorInput, Never>()
        let decimalSubject = PassthroughSubject<Decimal?, Never>()

        let transformerInput = Transformer.Input(
            calculator:  calculatorSubject.eraseToAnyPublisher(),
            decimalValue: decimalSubject.eraseToAnyPublisher()
        )
        let output = transformer.transform(input: transformerInput)

        var received: String?
        let expectation = self.expectation(description: "Output")
        var count = keyboardInputs.count + 1 // inputs + decimal

        output.text
            .sink {
                received = $0
                count -= 1
                if count == 0 {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)

        for input in keyboardInputs {
            calculatorSubject.send(input)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            decimalSubject.send(decimal)
        }

        waitForExpectations(timeout: 0.5)
        XCTAssertEqual(received, expected)
    }
}
