import Foundation
import Combine

public extension CalculatorTextViewModel {
    var decimalValueOutput: AnyPublisher<Decimal?, Never> {
        decimalValueOutputSubject.eraseToAnyPublisher()
    }

    var decimalValueInput: PassthroughSubject<Decimal?, Never> {
        decimalValueInputSubject
    }

    var isFocused: AnyPublisher<Bool, Never> {
        isFocusedSubject.eraseToAnyPublisher()
    }
}

public class CalculatorTextViewModel: ObservableObject {

    @Published
    var text: String = ""

    public init() {}

    var keyboardInput: AnyPublisher<KeyboardInput, Never>? {
        didSet {
            if oldValue == nil, let keyboardInput = keyboardInput {
                configureTransformer(keyboardInput)
            }
        }
    }

    let isFocusedSubject = PassthroughSubject<Bool, Never>()

    private let decimalValueInputSubject = PassthroughSubject<Decimal?, Never>()
    private let decimalValueOutputSubject = CurrentValueSubject<Decimal?, Never>(nil)

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
        let input = Transformer.Input(
            keyboard: keyboardInput,
            decimalValue: decimalValueInputSubject.eraseToAnyPublisher()
        )

        let output = transformer.transform(input: input)

        output
            .text
            .sink { [unowned self] in
                self.text = $0
            }
            .store(in: &subscriptions)

        output
            .decimalValue
            .sink { [unowned self] in
                self.decimalValueOutputSubject.send($0)
            }
            .store(in: &subscriptions)
    }
}
