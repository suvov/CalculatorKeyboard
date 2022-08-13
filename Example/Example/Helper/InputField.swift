//
//  InputField.swift
//  Example
//
//  Created by Vladimir Shutyuk on 12.08.2022.
//

import SwiftUI

struct InputField: ViewModifier {
    func body(content: Content) -> some View {
        Divider()
        content
            .padding()
            .frame(height: 44)
        Divider()
    }
}
