//
//  ContentView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 15.06.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DecimalInputExampleView()
                .tabItem {
                    Label("Decimal input", systemImage: "textformat.123")
                }
            ConnectedInputsExampleView()
                .tabItem {
                    Label("Connected inputs", systemImage: "arrow.2.squarepath")
                }
            TextAndDecimalExampleView()
                .tabItem {
                    Label("Text and decimal", systemImage: "textformat.superscript")
                }
        }
    }
}
