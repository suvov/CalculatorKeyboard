//
//  ContentView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 15.06.22.
//

import SwiftUI

struct ContentView: View {
    private let oneField = false

    var body: some View {
        VStack {
            if oneField {
                OneFieldView(model: OneFieldViewModel())
            } else {
                TwoFieldsView(model: TwoFieldsViewModel())
            }
            Spacer()
        }
        .padding(.top)
    }
}
