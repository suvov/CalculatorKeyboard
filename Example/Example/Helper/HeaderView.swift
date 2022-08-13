//
//  HeaderView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 13.08.2022.
//

import SwiftUI

struct HeaderView: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.secondary)
                .font(.caption)
            Spacer()
        }.padding()
    }
}
