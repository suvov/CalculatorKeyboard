//
//  DecimalInputExampleView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.08.22.
//

import SwiftUI
import CalculatorKeyboard

struct DecimalInputExampleView: View {
    
    @State
    private var decimalValue: Decimal?

    @FocusState
    private var focusedField: Bool

    var body: some View {
        VStack {
            Text("🇺🇸 USD").font(.caption)
            CalculatorTextFieldView(decimalValue: $decimalValue)
                .focused($focusedField)
                .modifier(InputField())
            DisplayValueView(value: decimalValue?.description)
            SetValueView(setValue: {
                self.decimalValue = $0
            })
            Spacer()
            HideKeyboardButton() { focusedField = false }
        }.padding(.vertical)
    }
}
