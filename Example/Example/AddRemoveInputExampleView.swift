//
//  AddRemoveInputExampleView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 13.08.2022.
//

import SwiftUI
import CalculatorKeyboard

struct AddRemoveInputExampleView: View {

    @State
    private var isHidden: Bool = false

    @State
    private var decimalValue: Decimal?

    var body: some View {
        VStack {
            if isHidden {
                Text("Input is removed")
            } else {
                Group {
                    Text("🇺🇸 USD").font(.caption)
                    CalculatorTextFieldView(decimalValue: $decimalValue)                .modifier(InputField())
                }
            }
            Button(isHidden ? "Add input" : "Remove input", action: {
                isHidden.toggle()
            }).padding()
            Spacer()
            HideKeyboardButton()
        }.padding(.vertical)
    }
}
