//
//  DisplayValueView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 06.07.2022.
//

import SwiftUI

struct DisplayValueView: View {
    var value: String

    var body: some View {
        HStack {
            Text("Current value:")
            Spacer()
            Text(value)
                .foregroundColor(.red)
        }
        .padding()
        Divider()
    }
}
