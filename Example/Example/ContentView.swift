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
            OneInputExampleView()
                .tabItem {
                    Label("One field", systemImage: "textformat.123")
                }
            TwoInputsExampleView()
                .tabItem {
                    Label("Two fields", systemImage: "arrow.2.squarepath")
                }
            NameAndValueExampleView()
                .tabItem {
                    Label("Name value", systemImage: "textformat.superscript")
                }
        }
    }
}
