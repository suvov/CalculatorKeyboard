import UIKit

final class ButtonFactory {
    private let titleColor = UIColor.label

    func makeDigit(with digit: Digit) -> UIButton {
        DigitButton(digit: digit, titleColor: titleColor)
    }

    func makeSeparator() -> UIButton  {
        makeWithTitle(Locale.autoupdatingCurrent.decimalSeparator ?? ".")
    }

    func makeBackspace() -> UIButton  {
        makeWithSystemImageName("delete.left", highlighted: "delete.left.fill")
    }

    func makeEqual() -> UIButton  {
        makeWithSystemImageName("equal.circle", highlighted: "equal.circle.fill")
    }

    func makeAddition() -> UIButton  {
        makeWithSystemImageName("plus.circle", highlighted: "plus.circle.fill")
    }

    func makeSubtraction() -> UIButton  {
        makeWithSystemImageName("minus.circle", highlighted: "minus.circle.fill")
    }

    func makeMultiplication() -> UIButton  {
        makeWithSystemImageName("multiply.circle", highlighted: "multiply.circle.fill")
    }

    func makeDivision() -> UIButton {
        makeWithSystemImageName("divide.circle", highlighted: "divide.circle.fill")
    }
}

private extension ButtonFactory {
    func makeWithSystemImageName(_ normal: String, highlighted: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = titleColor
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: normal, withConfiguration: configuration)
        let highlightedImage = UIImage(systemName: highlighted, withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        return button
    }
    
    func makeWithTitle(_ title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }
}
