import UIKit

final class DigitButton: UIButton {
    private let config: DigitButtonConfig

    init(digit: Digit, titleColor: UIColor, config: DigitButtonConfig = .default) {
        self.config = config
        super.init(frame: .zero)
        backgroundColor = .clear
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel?.adjustsFontForContentSizeCategory = true
        setTitle("\(digit.rawValue)", for: .normal)
        setTitleColor(titleColor, for: .normal)
        setImages()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setImages() {
        let normal = UIImage.digitButtonBackground(
            radius: config.cornerRadius,
            foregroundColor: config.normalColor,
            shadowColor: config.shadowColor,
            shadowHeight: config.shadowHeight
        )
        let highlighted = UIImage.digitButtonBackground(
            radius: config.cornerRadius,
            foregroundColor: config.highlightedColor,
            shadowColor: config.shadowColor,
            shadowHeight: config.shadowHeight
        )

        setBackgroundImage(normal, for: .normal)
        setBackgroundImage(highlighted, for: .highlighted)
    }

    // MARK: -

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setImages()
    }
}

struct DigitButtonConfig {
    init(normalColor: UIColor,
         highlightedColor: UIColor,
         shadowColor: UIColor,
         cornerRadius: CGFloat,
         shadowHeight: CGFloat) {
        self.normalColor = normalColor
        self.highlightedColor = highlightedColor
        self.shadowColor = shadowColor
        self.cornerRadius = cornerRadius
        self.shadowHeight = shadowHeight
    }

    let normalColor: UIColor
    let highlightedColor: UIColor
    let shadowColor: UIColor

    let cornerRadius: CGFloat
    let shadowHeight: CGFloat
}

extension DigitButtonConfig {
    static var `default`: Self {
        let normal: UIColor = {
            let dark = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
            let light = UIColor.white
            return UIColor { traits -> UIColor in
                traits.userInterfaceStyle == .dark ? dark : light
            }
        }()

        let highlighted: UIColor = {
            let dark = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)
            let light = UIColor(red: 183/255, green: 195/255, blue: 208/255, alpha: 1)
            return UIColor { traits -> UIColor in
                traits.userInterfaceStyle == .dark ? dark : light
            }
        }()

        let shadow: UIColor = {
            let dark = UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1)
            let light = UIColor(red: 136/255, green: 138/255, blue: 141/255, alpha: 1)
            return UIColor { traits -> UIColor in
                traits.userInterfaceStyle == .dark ? dark : light
            }
        }()

        let cornerRadius: CGFloat = 8
        let shadowHeight: CGFloat = 1

        return DigitButtonConfig(normalColor: normal,
                                 highlightedColor: highlighted,
                                 shadowColor: shadow,
                                 cornerRadius: cornerRadius,
                                 shadowHeight: shadowHeight)
    }
}

private extension UIImage {
    static func digitButtonBackground(radius: CGFloat,
                                      foregroundColor: UIColor,
                                      shadowColor: UIColor,
                                      shadowHeight: CGFloat) -> UIImage? {
        let width = (radius * 2) + 1
        let height = width + shadowHeight
        let frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))

        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)

        let context = UIGraphicsGetCurrentContext()
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: 0, height: shadowHeight)
        shadow.shadowBlurRadius = 0
        var buttonFrame = frame
        buttonFrame.size.height -= shadowHeight

        context?.saveGState()

        context?.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: shadowColor.cgColor)
        let buttonPath = UIBezierPath(roundedRect: buttonFrame, cornerRadius: radius)
        foregroundColor.setFill()
        buttonPath.fill()

        context?.restoreGState()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let insets = UIEdgeInsets(top: radius, left: radius, bottom: radius + shadowHeight, right: radius)
        return image?.resizableImage(withCapInsets: insets)
    }
}
