import Foundation
import Combine

final class Transformer {
    struct Output {
        let text: String
        let decimalValue: Decimal?
    }
    
    private let reducer: Reducer
    private let formatter: Formatter

    init(reducer: Reducer, formatter: Formatter) {
        self.reducer = reducer
        self.formatter = formatter
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        var expression = Expression.empty
        return input
            .map { [unowned self] input -> Output in
                expression = self.reducer.reduce(expression, with: input)
                let text = self.formatter.string(from: expression)
                let decimalValue = expression.value
                return Output(text: text, decimalValue: decimalValue)
            }
            .eraseToAnyPublisher()
    }
}
