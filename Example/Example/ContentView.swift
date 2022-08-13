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
                    Label("One field", systemImage: "textformat.superscript")
                }
            TwoInputsExampleView()
                .tabItem {
                    Label("Two fields", systemImage: "arrow.2.squarepath")
                }
            AddRemoveInputExampleView()
                .tabItem {
                    Label("Remove field", systemImage: "pause")
                }
        }
    }
}
