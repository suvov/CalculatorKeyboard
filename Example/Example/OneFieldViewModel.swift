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
    let textFieldModel = CalculatorTextViewModel()

    private var subscriptions = Set<AnyCancellable>()

    init() {
        textFieldModel.decimalValueOutput
            .sink { [unowned self] in
                if let value = $0 {
                    self.currentDecimalValueDescription = "\(value)"
                } else {
                    self.currentDecimalValueDescription = "nil"
                }
            }
            .store(in: &subscriptions)
    }

    func setDecimal(_ decimal: Decimal?) {
        textFieldModel.decimalValueInput.send(decimal)
    }

    @Published
    var currentDecimalValueDescription: String = "nil"
}
