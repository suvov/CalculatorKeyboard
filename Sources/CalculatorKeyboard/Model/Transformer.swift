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
    private let setDecimalDebounce: TimeInterval

    init(reducer: Reducer,
         formatter: Formatter,
         setDecimalDebounce: TimeInterval = 0.5) {
        self.reducer = reducer
        self.formatter = formatter
        self.setDecimalDebounce = setDecimalDebounce
    }

    func transform(input: Input) -> Output {
        var currentExpression = Expression.empty
        var lastCalculatorInputTime: TimeInterval?

        let expressionFromCalculatorInput = input.calculator
            .map { [unowned self] keyboardInput -> Expression in
                lastCalculatorInputTime = ProcessInfo.processInfo.systemUptime
                return self.reducer.reduce(currentExpression, with: keyboardInput)
            }
            .share()
            .eraseToAnyPublisher()
        
        let expressionFromDecimalValueInput = input.decimalValue
            .compactMap { [unowned self] value -> Expression? in
                if self.enoughTimePassedSince(lastCalculatorInputTime) {
                    return Expression.makeWithValue(value)
                } else {
                    return nil
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

private extension Transformer {
    func enoughTimePassedSince(_ lastCalculatorInputTime: TimeInterval?) -> Bool {
        guard let lastCalculatorInputTime = lastCalculatorInputTime else {
            return true
        }
        /* if it was less than provided decimal debounce since last calculator input,
         we assume that decimal input happens as a result of
         calculator input.
         */
        let timeElapsed = ProcessInfo.processInfo.systemUptime - lastCalculatorInputTime
        return timeElapsed > setDecimalDebounce
    }
}
