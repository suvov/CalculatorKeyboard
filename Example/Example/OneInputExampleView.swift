//
//  OneInputExampleView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.08.22.
//

import SwiftUI
import CalculatorKeyboard

struct OneInputExampleView: View {
    
    @State
    private var decimalValue: Decimal?

    var body: some View {
        VStack {
            Text("🇺🇸 USD").font(.caption)
            CalculatorTextFieldView(decimalValue: $decimalValue)                .modifier(InputField())
            DisplayValueView(value: decimalValue?.description)
            SetValueView(setValue: {
                self.decimalValue = $0
            })
            Spacer()
            HideKeyboardButton()
        }.padding(.vertical)
    }
}
