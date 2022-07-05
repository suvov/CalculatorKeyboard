//
//  OneFieldViewModel.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.07.2022.
//

import Foundation
import Combine
import CalculatorKeyboard

final class OneFieldViewModel: ObservableObject {
    let calculatorTextViewModel = CalculatorTextViewModel()

    private var subscriptions = Set<AnyCancellable>()

    init() {
        calculatorTextViewModel.decimalValueOutput
            .sink { [unowned self] in
                if let value = $0 {
                    self.decimalValueDescription = "\(value)"
                } else {
                    self.decimalValueDescription = "nil"
                }
            }
            .store(in: &subscriptions)
    }

    func setDecimal(_ decimal: Decimal?) {
        calculatorTextViewModel.decimalValueInput.send(decimal)
    }

    @Published
    var decimalValueDescription: String = "nil"
}
