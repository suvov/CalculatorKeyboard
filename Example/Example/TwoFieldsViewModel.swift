//
//  TwoFieldsViewModel.swift
//  Example
//
//  Created by Vladimir Shutyuk on 05.07.2022.
//

import Foundation
import Combine

final class TwoFieldsViewModel: ObservableObject {
    let textFieldModelOne = OneFieldViewModel()
    let textFieldModelTwo = OneFieldViewModel()

    private var subscriptions = Set<AnyCancellable>()

    init() {
        
    }
}
