import UIKit

public struct UITextFieldConfig {
    let font: UIFont
    let adjustsFontSizeToFitWidth: Bool
    let textAlignment: NSTextAlignment
    let placeholder: String?

    public init(
        font: UIFont = UIFont.preferredFont(forTextStyle: .title1),
        adjustsFontSizeToFitWidth: Bool = true,
        textAlignment: NSTextAlignment = .left,
        placeholder: String? = "0"
    ) {
        self.font = font
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        self.textAlignment = textAlignment
        self.placeholder = placeholder
    }
}
