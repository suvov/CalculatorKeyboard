//
//  CalculatorSUITextField.swift
//  Example
//
//  Created by Vladimir Shutyuk on 19.06.22.
//

import SwiftUI
import CalculatorKeyboard

struct CalculatorSUITextField: UIViewRepresentable {
    func updateUIView(_ uiView: UITextField, context: Context) {
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextField {
        let textField = CalculatorTextField()
        textField.font = UIFont.preferredFont(forTextStyle: .title1)
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .right
        textField.placeholder = "0"
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }
}
