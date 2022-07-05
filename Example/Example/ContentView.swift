//
//  ContentView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 15.06.22.
//

import SwiftUI
import Introspect

struct ContentView: View {
    
    var body: some View {
        OneFieldView(model: OneFieldViewModel())
            .introspectTextField { textField in
                textField.becomeFirstResponder()
            }
            .padding(.top)
    }
}
