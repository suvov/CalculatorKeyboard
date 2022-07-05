//
//  OneFieldView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 29.06.2022.
//

import SwiftUI
import CalculatorKeyboard

struct OneFieldView: View {

    @ObservedObject
    var model: OneFieldViewModel

    var body: some View {
        VStack {
            Divider()
            CalculatorTextView(model: model.calculatorTextViewModel)
                .padding()
                .frame(height: 44)

            Divider()

            HStack {
                Text("Current value:")
                Spacer()
                Text("\(model.decimalValueDescription)")
                    .foregroundColor(.red)
            }
            .padding()

            Divider()

            HStack {
                Text("Set value:")
                Spacer()
                Button("nil", action: {
                    model.setDecimal(nil)
                })
                .padding(.horizontal)

                Button("5.99", action: {
                    model.setDecimal(Decimal(string: "5.99"))
                })
                .padding(.horizontal)

                Button("10", action: {
                    model.setDecimal(Decimal(string: "10"))
                })
                .padding(.horizontal)
            }
            .padding()

            Spacer()
        }
    }
}
