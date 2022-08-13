//
//  HideKeyboardButton.swift
//  Example
//
//  Created by Vladimir Shutyuk on 12.08.2022.
//

import SwiftUI

struct HideKeyboardButton: View {
    var body: some View {
        HStack {
            Spacer()
            Button("Hide keyboard", action: { self.endEditing() })
        }.padding()
    }
}
