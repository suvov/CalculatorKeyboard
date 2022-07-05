import Foundation
import Combine

public extension CalculatorTextViewModel {
    var decimalValueOutput: AnyPublisher<Decimal?, Never> {
        decimalValueOutputSubject.eraseToAnyPublisher()
    }

    var decimalValueInput: PassthroughSubject<Decimal?, Never> {
        decimalValueInputSubject
    }
}

public class CalculatorTextViewModel: ObservableObject {

    @Published
    var text: String = ""

    public init() {}

    func setInput(_ keyboardInput: AnyPublisher<KeyboardInput, Never>) {
        configureTransformer(keyboardInput)
    }

    private let decimalValueInputSubject = PassthroughSubject<Decimal?, Never>()
    private let decimalValueOutputSubject = PassthroughSubject<Decimal?, Never>()

    private let transformer: Transformer = {
        let validator = Validator()
        let evaluator = Evaluator()
        let reducer = Reducer(validator: validator, evaluator: evaluator)
        let formatter = Formatter(validator: validator)
        return .init(reducer: reducer, formatter: formatter)
    }()

    private var subscriptions = Set<AnyCancellable>()
}

private extension CalculatorTextViewModel {
    func configureTransformer(_ keyboardInput: AnyPublisher<KeyboardInput, Never>) {
        let transformerInput = Transformer.Input(
            keyboard: keyboardInput,
            decimalValue: decimalValueInputSubject.eraseToAnyPublisher()
        )
        transformer.transform(input: transformerInput)
            .text
            .sink { [unowned self] in
                self.text = $0
            }
            .store(in: &subscriptions)

        transformer.transform(input: transformerInput)
            .decimalValue
            .sink { [unowned self] in
                self.decimalValueOutputSubject.send($0)
            }
            .store(in: &subscriptions)
    }
}
