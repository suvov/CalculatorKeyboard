//
//  TwoFieldsView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.07.2022.
//

import SwiftUI
import Introspect
import CalculatorKeyboard

struct TwoFieldsView: View {
    
    @ObservedObject
    var model: TwoFieldsViewModel
    
    var body: some View {
        ScrollView {
            Text("🇺🇸 USD").font(.caption)
            OneFieldView(model: model.textFieldModelOne)
            Text("🇪🇺 EUR").font(.caption)
            OneFieldView(model: model.textFieldModelTwo)
        }
    }
}
