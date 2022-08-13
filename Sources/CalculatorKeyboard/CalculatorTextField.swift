import UIKit
import Combine

public class CalculatorTextField: UITextField {
    private lazy var transformer: Transformer = {
        let validator = Validator()
        let evaluator = Evaluator()
        let formatter = Formatter(validator: validator)
        let reducer = Reducer(validator: validator, evaluator: evaluator)
        return Transformer(reducer: reducer, formatter: formatter)
    }()

    private var subcriptions = Set<AnyCancellable>()
    private let decimalValueInputSubject = PassthroughSubject<Decimal?, Never>()

    public var onDecimalValueChange: ((Decimal?) -> Void)?

    public func setDecimalValue(_ value: Decimal?) {
        decimalValueInputSubject.send(value)
    }

    public init() {
        super.init(frame: .zero)
        let keyboard = Keyboard()
        inputView = keyboard
        let input = Transformer.Input(
            calculator: keyboard.output,
            decimalValue: decimalValueInputSubject.eraseToAnyPublisher()
        )
        let output = transformer.transform(input: input)
        
        output.text
            .sink { [unowned self] in
                self.text = $0
            }
            .store(in: &subcriptions)

        output.decimalValue
            .sink { [unowned self] in
                self.onDecimalValueChange?($0)
            }
            .store(in: &subcriptions)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // disable paste in
    public override func canPerformAction(_ action: Selector,
                                          withSender sender: Any?) -> Bool {
        false
    }
}
