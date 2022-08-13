//
//  NameAndValueExampleView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 13.08.2022.
//

import SwiftUI
import CalculatorKeyboard

struct NameAndValueExampleView: View {

    @StateObject
    private var viewModel = ViewModel()

    enum Field: Hashable {
        case name
        case value
    }

    @FocusState
    private var focusedField: Field?

    var body: some View {
        VStack {
            if showsName {
                HeaderView("NAME")
                TextField("name", text: $viewModel.name)
                    .font(.title)
                    .focused($focusedField, equals: .name)
                    .modifier(InputField())
            }
            if showsValue {
                HeaderView("VALUE")
                CalculatorTextFieldView(decimalValue: $viewModel.value)
                    .focused($focusedField, equals: .value)
                    .modifier(InputField())
            }
            Spacer()
            HideKeyboardButton() { focusedField = nil }
        }
        .animation(.spring(), value: focusedField)
        .padding(.vertical)
    }

    private var showsName: Bool {
        focusedField == .name || focusedField == nil
    }

    private var showsValue: Bool {
        focusedField == .value || focusedField == nil
    }
}

struct DecimalAndTextExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NameAndValueExampleView()
    }
}

private extension NameAndValueExampleView {

    final class ViewModel: ObservableObject {
        @Published
        var name: String = ""

        @Published
        var value: Decimal?
    }
}
