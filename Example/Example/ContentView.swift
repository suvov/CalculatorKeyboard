//
//  ContentView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 15.06.22.
//

import SwiftUI
import Calcboard

struct ContentView: View {
    var body: some View {
        Text(Calcboard().text)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
