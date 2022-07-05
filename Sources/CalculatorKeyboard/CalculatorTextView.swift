import SwiftUI
import Combine

public struct CalculatorTextView: UIViewRepresentable {

    public init(model: CalculatorTextViewModel){
        let keyboard = Keyboard()
        self.inputView = keyboard
        self.model = model
        model.setInput(keyboard.output)
    }

    private let inputView: UIView
    
    @ObservedObject
    private var model: CalculatorTextViewModel

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = model.text
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextField {
        let textField = UIKitTextField()
        textField.font = UIFont.preferredFont(forTextStyle: .title1)
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .right
        textField.placeholder = "0"
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.inputView = inputView
        return textField
    }
}

private class UIKitTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
}
