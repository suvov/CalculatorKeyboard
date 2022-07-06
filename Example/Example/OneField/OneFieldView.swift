//
//  OneFieldView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 29.06.2022.
//

import SwiftUI

struct OneFieldView: View {

    @ObservedObject
    var model: OneFieldViewModel

    var body: some View {
        VStack {
            DecimalInputView(model: model.textFieldModel)
            DisplayValueView(value: model.decimalValueDescription)
            SetValueView(setValue: model.setDecimal(_:))
        }
    }
}
