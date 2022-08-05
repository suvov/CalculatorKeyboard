//
//  CalculatorTextFieldView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.08.22.
//

import SwiftUI
import Combine
import CalculatorKeyboard

struct CalculatorTextFieldView: UIViewRepresentable {

    @Binding
    var decimalValue: Decimal?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextField {
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

    func updateUIView(_ uiView: UITextField, context: Context) {
        (uiView as? CalculatorTextField)?.setDecimalValue(decimalValue)
    }

    func makeCoordinator() -> Self.Coordinator {
        Coordinator(self)
    }

    class Coordinator {

        func setDecimalValue(_ value: Decimal?) {
            parent.decimalValue = value
        }

        private var parent: CalculatorTextFieldView

        init(_ parent: CalculatorTextFieldView) {
            self.parent = parent
        }
    }
}
