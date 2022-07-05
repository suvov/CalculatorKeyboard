import SwiftUI
import Combine

public struct CalculatorTextView: UIViewRepresentable {

    public init(model: CalculatorTextViewModel,
                customTextField: UITextField? = nil) {
        self.model = model
        self.textField = customTextField ?? DefaultUITextField()
        let keyboard = Keyboard()
        self.textField.inputView = keyboard
        model.keyboardInput = keyboard.output
    }

    @ObservedObject
    private var model: CalculatorTextViewModel
    private let textField: UITextField

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = model.text
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextField {
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }
}

private class DefaultUITextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.preferredFont(forTextStyle: .title1)
        adjustsFontSizeToFitWidth = true
        textAlignment = .right
        placeholder = "0"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
}
