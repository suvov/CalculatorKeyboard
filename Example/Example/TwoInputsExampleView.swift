//
//  TwoInputsExampleView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 12.08.2022.
//

import SwiftUI

struct TwoInputsExampleView: View {

    @StateObject
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Text("🇺🇸 USD").font(.caption)
            CalculatorTextFieldView(decimalValue: $viewModel.usdDecimalValue)
                .modifier(InputField())
            Text("🇬🇧 GBP").font(.caption)
            CalculatorTextFieldView(decimalValue: $viewModel.gbpDecimalValue)                .modifier(InputField())
            Spacer()
            HideKeyboardButton()
        }.padding(.vertical)
    }
}

private extension TwoInputsExampleView {
    final class ViewModel: ObservableObject {
        private let gbpUsdRate: Decimal
        private let usdGbpRate: Decimal

        init() {
            gbpUsdRate = 1.2
            usdGbpRate = 1 / gbpUsdRate
        }

        @Published
        var usdDecimalValue: Decimal? {
            didSet {
                if oldValue.isEqualOrBothNil(to: usdDecimalValue) {
                    return
                }
                if let usdDecimalValue = usdDecimalValue {
                    print("🇺🇸 USD \(usdDecimalValue)")
                    gbpDecimalValue = (usdDecimalValue * gbpUsdRate).rounded()
                } else {
                    print("🇺🇸 USD nil")
                    gbpDecimalValue = nil
                }
            }
        }

        @Published
        var gbpDecimalValue: Decimal? {
            didSet {
                if oldValue.isEqualOrBothNil(to: gbpDecimalValue) {
                    return
                }
                if let gbpDecimalValue = gbpDecimalValue {
                    print("🇬🇧 GBP \(gbpDecimalValue)")
                    usdDecimalValue = (gbpDecimalValue * usdGbpRate).rounded()
                } else {
                    print("🇬🇧 GBP nil")
                    usdDecimalValue = nil
                }
            }
        }
    }
}
