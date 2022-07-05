//
//  OneFieldView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 29.06.2022.
//

import SwiftUI
import Introspect
import CalculatorKeyboard

struct OneFieldView: View {

    @ObservedObject
    var model: OneFieldViewModel

    var body: some View {
        Divider()
            .padding(.top)
        CalculatorTextView(model: model.textFieldModel)
            .introspectTextField { textField in
                textField.becomeFirstResponder()
            }
            .frame(height: 44)
            .padding()

        Divider()

        HStack {
            Text("Current value:")
            Spacer()
            Text("\(model.currentDecimalValueDescription)")
                .foregroundColor(.red)
        }
        .padding()

        Divider()

        HStack {
            Text("Set value:")
            Spacer()
            Button("nil", action: {
                model.setDecimal(nil)
            }).padding(.horizontal)

            Button("499.99", action: {
                model.setDecimal(Decimal(string: "499.99"))
            }).padding(.horizontal)

            Button("1000", action: {
                model.setDecimal(Decimal(string: "1000"))
            }).padding(.horizontal)

        }
        .padding()

        Spacer()
    }
}
