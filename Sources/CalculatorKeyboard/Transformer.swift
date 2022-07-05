import Foundation
import Combine

extension Transformer {
    struct Input {
        let keyboard: AnyPublisher<KeyboardInput, Never>
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

        let expressionFromKeyboardInput = input.keyboard
            .map { [unowned self] keyboardInput -> Expression in
                return self.reducer.reduce(localExpression, with: keyboardInput)
            }
            .eraseToAnyPublisher()

        let expressionFromDecimalValueInput = input.decimalValue
            .map { decimalValue -> Expression in
                if let decimalValue = decimalValue {
                    return .lhs(decimalValue.string)
                } else {
                    return .empty
                }
            }

        let expression = Publishers.Merge(
            expressionFromKeyboardInput,
            expressionFromDecimalValueInput
        ).handleEvents(receiveOutput: {
            localExpression = $0
        }).share()

        let text = expression.map { [unowned self] in
            self.formatter.string(from: $0)
        }.eraseToAnyPublisher()

        let decimalValue = expression.map {
            $0.value
        }.eraseToAnyPublisher()

        return Output(text: text, decimalValue: decimalValue)
    }
}

private extension Decimal {
    var string: String {
        var value = self
        return NSDecimalString(&value, Constants.locale)
    }
}
