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
        var localExpression = Expression.empty

        let expressionFromCalculatorInput = input.calculator
            .map { [unowned self] keyboardInput -> Expression in
                return self.reducer.reduce(localExpression, with: keyboardInput)
            }
            .share()
            .eraseToAnyPublisher()
        
        let expressionFromDecimalValueInput = input.decimalValue
            .map {
                Expression.makeWithValue($0)
            }

        let expression = Publishers.Merge(
            expressionFromCalculatorInput,
            expressionFromDecimalValueInput
        ).handleEvents(receiveOutput: {
            localExpression = $0
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
