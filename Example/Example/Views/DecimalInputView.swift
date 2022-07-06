//
//  DecimalInputView.swift
//  Example
//
//  Created by Vladimir Shutyuk on 06.07.2022.
//

import SwiftUI
import CalculatorKeyboard

struct DecimalInputView: View {
    let model: CalculatorTextViewModel

    var body: some View {
        Divider()
        CalculatorTextView(model: model, customTextField: CustomUITextField())
            .padding()
            .frame(height: 44)
        Divider()
    }
}

private class CustomUITextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.preferredFont(forTextStyle: .title1)
        adjustsFontSizeToFitWidth = true
        textAlignment = .right
        placeholder = "0.00"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
}
