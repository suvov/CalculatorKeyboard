import Combine
import XCTest
@testable import Calcboard

class TransformerTests: XCTestCase {

    private var subscriptions: Set<AnyCancellable>!

    private let transformer = Transformer(
        reducer: Reducer(validator: Validator(),
                         evaluator: Evaluator()),
        formatter: Formatter(validator: Validator())
    )

    override func setUp() {
        super.setUp()
        subscriptions = []
    }
    
    func testLhsCase1() {
        let inputs: [Input] = [.digit(.one)]
        let expectedOutput = Transformer.Output(text: "1", decimalValue: Decimal(string: "1")!)
        testTransformsInputs(inputs, into: expectedOutput)
    }
    
    func testLhsCase2() {
        let inputs: [Input] = [.digit(.one),
                              .decimalSeparator,
                              .digit(.zero),
                              .digit(.one)]
        let expectedOutput = Transformer.Output(text: "1.01", decimalValue: Decimal(string: "1.01"))
        testTransformsInputs(inputs, into: expectedOutput)
    }
    
    func testLhsCase3() {
        let inputs: [Input] = [.digit(.one),
                              .decimalSeparator,
                              .digit(.one)]
        let expectedOutput = Transformer.Output(text: "1.1",
                                              decimalValue: Decimal(string: "1.1"))
        testTransformsInputs(inputs, into: expectedOutput)
    }
    
    func testLhsCase4() {
        let inputs: [Input] = [.digit(.one),
                              .decimalSeparator,
                              .digit(.one),
                              .digit(.zero)]
        let expectedOutput = Transformer.Output(text: "1.1",
                                              decimalValue: Decimal(string: "1.1"))
        testTransformsInputs(inputs, into: expectedOutput)
    }
    
    func testLhsOperator() {
        let inputs: [Input] = [.digit(.nine),
                               .decimalSeparator,
                               .digit(.two),
                               .arithmeticOperator(.addition)]
        let expectedOutput = Transformer.Output(text: "9.2 + ", decimalValue: nil)
        testTransformsInputs(inputs, into: expectedOutput)
    }
    
    func testLhsOperatorRhs() {
        let inputs: [Input] = [.digit(.three),
                               .decimalSeparator,
                               .digit(.two),
                               .arithmeticOperator(.addition),
                               .digit(.four),
                               .decimalSeparator,
                               .digit(.eight)]
        let expectedOutput = Transformer.Output(text: "3.2 + 4.8", decimalValue: nil)
        testTransformsInputs(inputs, into: expectedOutput)
    }
    
    func testCalculates() {
        let inputs: [Input] = [.digit(.three),
                               .decimalSeparator,
                               .digit(.two),
                               .arithmeticOperator(.addition),
                               .digit(.four),
                               .decimalSeparator,
                               .digit(.eight),
                               .equals]
        let expectedOutput = Transformer.Output(text: "8", decimalValue: Decimal(string: "8"))
        testTransformsInputs(inputs, into: expectedOutput)
    }
}

private extension TransformerTests {
    func testTransformsInputs(_ inputs: [Input], into expectedOutput: Transformer.Output) {
        let inputSubject = PassthroughSubject<Input, Never>()
        
        let output = transformer.transform(input: inputSubject.eraseToAnyPublisher())
        
        var received: Transformer.Output?
        let expectation = self.expectation(description: "Output")
        var count = inputs.count
        output.sink {
            received = $0
            count -= 1
            if count == 0 {
                expectation.fulfill()
            }
        }
        .store(in: &subscriptions)
        
        for input in inputs {
            inputSubject.send(input)
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(received, expectedOutput)
    }
}

extension Transformer.Output: Equatable {
    public static func == (lhs: Transformer.Output, rhs: Transformer.Output) -> Bool {
        lhs.text == rhs.text && lhs.decimalValue == rhs.decimalValue
    }
}
