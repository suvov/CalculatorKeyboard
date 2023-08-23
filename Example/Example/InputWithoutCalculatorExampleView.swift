//
//  InputWithoutCalculatorExampleView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 23.08.2023.
//

import SwiftUI
import CalculatorKeyboard

struct InputWithoutCalculatorExampleView: View {

    @State
    private var decimalValue: Decimal?

    @FocusState
    private var focusedField: Bool

    var body: some View {
        VStack {
            Text("🇺🇸 USD").font(.caption)
            CalculatorTextFieldView(decimalValue: $decimalValue,
                                    showsCalculator: false)
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
