//
//  TextAndDecimalExampleView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 13.08.2022.
//

import SwiftUI
import CalculatorKeyboard

struct TextAndDecimalExampleView: View {

    @StateObject
    private var viewModel = ViewModel()

    @FocusState
    private var focusedField: Field?

    var body: some View {
        VStack {
            if showsName {
                HeaderView("Text")
                TextField("text", text: $viewModel.text)
                    .font(.title)
                    .focused($focusedField, equals: .text)
                    .modifier(InputField())
            }
            if showsValue {
                HeaderView("DECIMAL")
                CalculatorTextFieldView(decimalValue: $viewModel.decimal)
                    .focused($focusedField, equals: .decimal)
                    .modifier(InputField())
            }
            Spacer()
            HideKeyboardButton() { focusedField = nil }
        }
        .animation(.spring(), value: focusedField)
        .padding(.vertical)
    }
}

private extension TextAndDecimalExampleView {
    enum Field {
        case text
        case decimal
    }

    var showsName: Bool {
        focusedField == .text || focusedField == nil
    }

    var showsValue: Bool {
        focusedField == .decimal || focusedField == nil
    }
}

private extension TextAndDecimalExampleView {

    final class ViewModel: ObservableObject {
        @Published
        var text: String = ""

        @Published
        var decimal: Decimal?
    }
}
