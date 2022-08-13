//
//  ConnectedInputsExampleView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 12.08.2022.
//

import SwiftUI
import CalculatorKeyboard

struct ConnectedInputsExampleView: View {

    @StateObject
    private var viewModel = ViewModel()

    @FocusState
    private var focusedField: Field?

    var body: some View {
        VStack {
            Text("🇺🇸 USD").font(.caption)
            CalculatorTextFieldView(decimalValue: $viewModel.usdDecimal)
                .focused($focusedField, equals: .usd)
                .modifier(InputField())
            Text("🇬🇧 GBP").font(.caption)
            CalculatorTextFieldView(decimalValue: $viewModel.gbpDecimal)
                .focused($focusedField, equals: .gbp)
                .modifier(InputField())
            Spacer()
            HideKeyboardButton() { focusedField = nil }
        }.padding(.vertical)
    }
}

private extension ConnectedInputsExampleView {
    enum Field {
        case usd
        case gbp
    }
}

private extension ConnectedInputsExampleView {
    final class ViewModel: ObservableObject {
        private let gbpUsdRate: Decimal
        private let usdGbpRate: Decimal

        init() {
            usdGbpRate = 1.2
            gbpUsdRate = 1 / usdGbpRate
        }

        @Published
        var usdDecimal: Decimal? {
            didSet {
                if oldValue.isEqualOrBothNil(to: usdDecimal) {
                    return
                }
                if let usdDecimalValue = usdDecimal {
                    print("🇺🇸 USD \(usdDecimalValue)")
                    gbpDecimal = (usdDecimalValue * gbpUsdRate).rounded()
                } else {
                    print("🇺🇸 USD nil")
                    gbpDecimal = nil
                }
            }
        }

        @Published
        var gbpDecimal: Decimal? {
            didSet {
                if oldValue.isEqualOrBothNil(to: gbpDecimal) {
                    return
                }
                if let gbpDecimalValue = gbpDecimal {
                    print("🇬🇧 GBP \(gbpDecimalValue)")
                    usdDecimal = (gbpDecimalValue * usdGbpRate).rounded()
                } else {
                    print("🇬🇧 GBP nil")
                    usdDecimal = nil
                }
            }
        }
    }
}
