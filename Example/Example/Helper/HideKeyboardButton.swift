//
//  HideKeyboardButton.swift
//  Example
//
//  Created by Vladimir Shutyuk on 12.08.2022.
//

import SwiftUI

struct HideKeyboardButton: View {
    let action: () -> Void

    init(_ action: (() -> Void)? = nil) {
        self.action = action ?? { Self.endEditing() }
    }

    var body: some View {
        HStack {
            Spacer()
            Button("Hide keyboard", action: action)
        }.padding()
    }
}
