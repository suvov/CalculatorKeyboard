//
//  TwoFieldsViewModel.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.07.2022.
//

import Foundation
import Combine
import CalculatorKeyboard

final class TwoFieldsViewModel: ObservableObject {
    // MARK: Child models

    let textFieldModelUSD = CalculatorTextViewModel()
    let textFieldModelEUR = CalculatorTextViewModel()

    // MARK: Rates

    private let eurUSDRate: Decimal = 1.1
    private let usdEURRate: Decimal = 0.9

    // MARK: Focus

    private enum TextField {
        case usd, eur
    }

    private var currentFocus: TextField?

    private var subscriptions = Set<AnyCancellable>()

    init() {
        trackFocus()
        connectFields()
    }
}

private extension TwoFieldsViewModel {
    func trackFocus() {
        Publishers.CombineLatest(
            textFieldModelUSD.isFocused.prepend(false),
            textFieldModelEUR.isFocused.prepend(false)
        )
        .sink { [unowned self] usdFocus, eurFocus in
            if usdFocus {
                self.currentFocus = .usd
            } else if eurFocus {
                self.currentFocus = .eur
            } else {
                self.currentFocus = nil
            }
        }
        .store(in: &subscriptions)
    }

    func connectFields() {
        Publishers.CombineLatest(
            textFieldModelUSD.decimalValueOutput,
            textFieldModelEUR.decimalValueOutput
        )
        .sink { [unowned self] decimalUSD, decimalEUR in
            switch self.currentFocus {
            case .usd:
                var decimalEUR: Decimal?
                if let decimalUSD = decimalUSD {
                    decimalEUR = decimalUSD * self.usdEURRate
                }
                self.textFieldModelEUR.decimalValueInput.send(decimalEUR)
            case .eur:
                var decimalUSD: Decimal?
                if let decimalEUR = decimalEUR {
                    decimalUSD = decimalEUR * self.eurUSDRate
                }
                self.textFieldModelUSD.decimalValueInput.send(decimalUSD)
            case .none:
                break
            }
        }
        .store(in: &subscriptions)
    }
}
