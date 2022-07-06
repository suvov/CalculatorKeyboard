//
//  TwoFieldsView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.07.2022.
//

import SwiftUI

struct TwoFieldsView: View {
    
    @ObservedObject
    var model: TwoFieldsViewModel
    
    var body: some View {
        VStack {
            Text("🇺🇸 USD").font(.caption)
            DecimalInputView(model: model.textFieldModelUSD)
            Text("🇪🇺 EUR").font(.caption)
            DecimalInputView(model: model.textFieldModelEUR)
        }
    }
}
