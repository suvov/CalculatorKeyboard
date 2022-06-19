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
        Just(.init(text: "", decimalValue: nil)).eraseToAnyPublisher()
    }
}
