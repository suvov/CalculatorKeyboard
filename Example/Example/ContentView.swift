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
        Divider()
            .padding(.top)
        CalculatorSUITextField()
            .introspectTextField { textField in
                textField.becomeFirstResponder()
            }
            .frame(height: 44)
            .padding()
        Divider()
        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
