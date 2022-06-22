import UIKit
import Combine

extension CalculatorTextField {
    public var decimalValue: AnyPublisher<Decimal?, Never> {
        decimalValueSubject.eraseToAnyPublisher()
    }
}

public class CalculatorTextField: UITextField {
    private lazy var transformer: Transformer = {
        let validator = Validator()
        let evaluator = Evaluator()
        let formatter = Formatter(validator: validator)
        let reducer = Reducer(validator: validator, evaluator: evaluator)
        return Transformer(reducer: reducer, formatter: formatter)
    }()

    private var subcriptions = Set<AnyCancellable>()
    private let decimalValueSubject = PassthroughSubject<Decimal?, Never>()

    public init() {
        super.init(frame: .zero)
        let keyboard = Keyboard()
        inputView = keyboard
        transformer
            .transform(input: keyboard.output)
            .sink { [unowned self] in
                self.text = $0.text
                self.decimalValueSubject.send($0.decimalValue)
            }
            .store(in: &subcriptions)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func canPerformAction(_ action: Selector,
                                          withSender sender: Any?) -> Bool {
        false
    }
}
