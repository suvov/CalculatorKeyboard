import Foundation
import Combine

extension Transformer {
    struct Input {
        let calculator: AnyPublisher<CalculatorInput, Never>
        let decimalValue: AnyPublisher<Decimal?, Never>
    }

    struct Output {
        let text: AnyPublisher<String, Never>
        let decimalValue: AnyPublisher<Decimal?, Never>
    }
}

final class Transformer {
    private let reducer: Reducer
    private let formatter: Formatter

    init(reducer: Reducer, formatter: Formatter) {
        self.reducer = reducer
        self.formatter = formatter
    }

    func transform(input: Input) -> Output {
        var currentExpression = Expression.empty
        var lastCalculatorInput: Date?

        let expressionFromCalculatorInput = input.calculator
            .map { [unowned self] keyboardInput -> Expression in
                lastCalculatorInput = Date()
                return self.reducer.reduce(currentExpression, with: keyboardInput)
            }
            .share()
            .eraseToAnyPublisher()
        
        let expressionFromDecimalValueInput = input.decimalValue
            .compactMap { value -> Expression? in
                // if it was less than second since last calculator input,
                // we assume that decimal input happens as a result of
                // calculator input
                if let lastCalculatorInput = lastCalculatorInput,
                   Date().timeIntervalSince(lastCalculatorInput) < 1 {
                    return nil
                } else {
                    return Expression.makeWithValue(value)
                }
            }

        let expression = Publishers.Merge(
            expressionFromCalculatorInput,
            expressionFromDecimalValueInput
        ).handleEvents(receiveOutput: {
            currentExpression = $0
        })

        let text = expression.map { [unowned self] in
            self.formatter.string(from: $0)
        }.eraseToAnyPublisher()

        let decimalValue = expressionFromCalculatorInput.map {
            $0.value
        }.eraseToAnyPublisher()

        return Output(text: text, decimalValue: decimalValue)
    }
}
