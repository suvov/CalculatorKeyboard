import SwiftUI
import Combine

public struct CalculatorTextFieldView: UIViewRepresentable {

    @Binding
    private var decimalValue: Decimal?

    public init(decimalValue: Binding<Decimal?>) {
        _decimalValue = decimalValue
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextField {
        let textField = CalculatorTextField()
        textField.onDecimalValueChange = { [unowned coordinator = context.coordinator] in
            coordinator.setDecimalValue($0)
        }
        textField.font = UIFont.preferredFont(forTextStyle: .title1)
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .right
        textField.placeholder = "0"
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
