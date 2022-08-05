//
//  OneInputExampleView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.08.22.
//

import SwiftUI

struct OneInputExampleView: View {
    @State
    private var decimalValue: Decimal?

    var body: some View {
        VStack {
            CalculatorTextFieldView(onDecimalValueChange: {
                self.decimalValue = $0
            })
            DisplayValueView(value: decimalValue?.description)
        }
    }
}
