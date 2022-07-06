//
//  TwoFieldsView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.07.2022.
//

import SwiftUI
import Introspect

struct TwoFieldsView: View {
    
    @ObservedObject
    var model: TwoFieldsViewModel
    
    var body: some View {
        VStack {
            Text("🇺🇸 USD").font(.caption)
            DecimalInputView(model: model.textFieldModelUSD)
                .introspectTextField {
                    $0.becomeFirstResponder()
                }
            Text("🇪🇺 EUR").font(.caption)
            DecimalInputView(model: model.textFieldModelEUR)
        }
    }
}
