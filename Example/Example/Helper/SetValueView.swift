//
//  SetValueView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 06.07.2022.
//

import SwiftUI

struct SetValueView: View {
    let setValue: (Decimal?) -> Void

    var body: some View {
        HStack {
            Text("Set value:")
            Spacer()
            Button("nil", action: {
                setValue(nil)
            })
            .padding(.horizontal)

            Button("5.99", action: {
                setValue(Decimal(string: "5.99"))
            })
            .padding(.horizontal)

            Button("10", action: {
                setValue(Decimal(string: "10"))
            })
            .padding(.horizontal)
        }
        .padding()
    }
}
