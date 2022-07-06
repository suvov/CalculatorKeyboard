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
    // MARK: Child models

    let textFieldModel = CalculatorTextViewModel()

    func setDecimal(_ decimal: Decimal?) {
        textFieldModel.decimalValueInput.send(decimal)
    }

    @Published
    var decimalValueDescription: String = "nil"

    private var subscriptions = Set<AnyCancellable>()

    init() {
        configure()
    }
}

private extension OneFieldViewModel {
    func configure() {
        textFieldModel.decimalValueOutput
            .sink { [unowned self] in
                if let value = $0 {
                    self.decimalValueDescription = "\(value)"
                } else {
                    self.decimalValueDescription = "nil"
                }
            }
            .store(in: &subscriptions)
    }
}
