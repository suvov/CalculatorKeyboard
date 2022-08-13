import SwiftUI
import Combine

public struct CalculatorTextFieldView: UIViewRepresentable {

    @Binding
    private var decimalValue: Decimal?
    private let textFieldConfig: UITextFieldConfig

    public init(
        decimalValue: Binding<Decimal?>,
        textFieldConfig: UITextFieldConfig = UITextFieldConfig()
    ) {
        _decimalValue = decimalValue
        self.textFieldConfig = textFieldConfig
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextField {
        let textField = CalculatorTextField()
        textField.onDecimalValueChange = { [unowned coordinator = context.coordinator] in
            coordinator.setDecimalValue($0)
        }
        textField.font = textFieldConfig.font
        textField.adjustsFontSizeToFitWidth = textFieldConfig.adjustsFontSizeToFitWidth
        textField.textAlignment = textFieldConfig.textAlignment
        textField.placeholder = textFieldConfig.placeholder
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        (uiView as? CalculatorTextField)?.setDecimalValue(decimalValue)
    }

    public func makeCoordinator() -> Self.Coordinator {
        Coordinator(self)
    }

    public class Coordinator {
        private let parent: CalculatorTextFieldView

        init(_ parent: CalculatorTextFieldView) {
            self.parent = parent
        }

        func setDecimalValue(_ value: Decimal?) {
            parent.decimalValue = value
        }
    }
}
