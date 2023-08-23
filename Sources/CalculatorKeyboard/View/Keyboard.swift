import UIKit
import Combine

extension Keyboard {
    var output: AnyPublisher<CalculatorInput, Never> {
        outputSubject.eraseToAnyPublisher()
    }
}

final class Keyboard: UIView {
    private let buttonFactory: ButtonFactory
    private let calculatorPanel = UIView()
    private let outputSubject = PassthroughSubject<CalculatorInput, Never>()
    private let showsCalculator: Bool

    private lazy var calculatorButtons: [UIButton] = {
        var buttons = [UIButton]()
        buttons.append(buttonFactory.makeDivision())
        buttons.last?.addTarget(self,
                                action: #selector(divisionAction),
                                for: .touchUpInside)

        buttons.append(buttonFactory.makeMultiplication())
        buttons.last?.addTarget(self,
                                action: #selector(multiplicationAction),
                                for: .touchUpInside)

        buttons.append(buttonFactory.makeSubtraction())
        buttons.last?.addTarget(self,
                                action: #selector(subtractionAction),
                                for: .touchUpInside)

        buttons.append(buttonFactory.makeAddition())
        buttons.last?.addTarget(self, action: #selector(additionAction), for: .touchUpInside)

        buttons.append(buttonFactory.makeEqual())
        buttons.last?.addTarget(self,
                                action: #selector(equalAction),
                                for: .touchUpInside)
        return buttons
    }()

    private lazy var keypadButtons: [UIButton] = {
        var buttons = [UIButton]()
        for index in 0...11 {
            switch index {
            case 9:
                buttons.append(buttonFactory.makeSeparator())
                buttons.last?.addTarget(self,
                                        action: #selector(separatorAction),
                                        for: .touchUpInside)
            case 10:
                buttons.append(buttonFactory.makeDigit(with: .zero))
                buttons.last?.addTarget(self,
                                        action: #selector(digitAction(_:)),
                                        for: .touchUpInside)
            case 11:
                buttons.append(buttonFactory.makeBackspace())
                buttons.last?.addTarget(self,
                                        action: #selector(backspaceAction),
                                        for: .touchUpInside)
            default:
                if let digit = Digit(rawValue: index + 1) {
                    buttons.append(buttonFactory.makeDigit(with: digit))
                    buttons.last?.addTarget(self,
                                            action: #selector(digitAction(_:)),
                                            for: .touchUpInside)
                }
            }
        }
        return buttons
    }()

  init(buttonFactory: ButtonFactory = ButtonFactory(),
       showsCalculator: Bool = true) {
        self.buttonFactory = buttonFactory
        self.showsCalculator = showsCalculator
        super.init(frame: .zero)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutKeypad(layoutCalculator())
    }

    override public var intrinsicContentSize: CGSize {
        CGSize(width: 300, height: keyboardHeight)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        invalidateIntrinsicContentSize()
        updateCalculatorPanelColor()
    }
}

private extension Keyboard {
    func configure() {
        autoresizingMask = .flexibleHeight
        keypadButtons.forEach {
            addSubview($0)
        }
        if showsCalculator {
          addSubview(calculatorPanel)
          calculatorButtons.forEach {
            calculatorPanel.addSubview($0)
          updateCalculatorPanelColor()
        }
      }
    }
    
    func updateCalculatorPanelColor() {
        guard showsCalculator else { return }
        calculatorPanel.backgroundColor = (
            traitCollection.verticalSizeClass == .compact
        ) ? .clear : .systemGray6
    }
    
    func layoutCalculator() -> CGFloat {
        guard showsCalculator else { return .zero }
        var calculatorSize = CGSize(width: bounds.width, height: calculatorPanelHeight)
        calculatorSize.width -= safeAreaInsets.left
        calculatorSize.width -= safeAreaInsets.right
        calculatorPanel.frame = CGRect(origin: CGPoint(x: safeAreaInsets.left, y: 0), size: calculatorSize)
        let buttonWidth = (calculatorSize.width / CGFloat(calculatorButtons.count)).rounded(.down)
        let buttonSize = CGSize(width: buttonWidth, height: calculatorSize.height)
        
        var buttonFrame = CGRect(origin: .zero, size: buttonSize)
        
        for button in calculatorButtons {
            button.frame = buttonFrame
            buttonFrame.origin.x += buttonFrame.size.width
        }
        return calculatorSize.height
    }
    
    func layoutKeypad(_ originY: CGFloat) {
        let spacing: CGFloat = 8
        let keypadY = originY + spacing
        var keypadSize = CGSize(width: bounds.width, height: bounds.size.height - keypadY)
        keypadSize.width -= safeAreaInsets.left
        keypadSize.width -= safeAreaInsets.right
        keypadSize.width -= spacing * 2
        keypadSize.height -= safeAreaInsets.bottom
        keypadSize.height -= spacing
        var buttonSize = CGSize.zero
        buttonSize.width = ((keypadSize.width - (spacing * 2)) / 3).rounded(.down)
        buttonSize.height = ((keypadSize.height - (spacing * 3)) / 4).rounded(.down)
        
        let buttonX = safeAreaInsets.left + spacing
        var buttonFrame = CGRect(origin: CGPoint(x: buttonX, y: keypadY), size: buttonSize)
        
        for (index, button) in keypadButtons.enumerated() {
            button.frame = buttonFrame
            buttonFrame.origin.x += buttonFrame.size.width + spacing
            // Next row of buttons.
            if [2, 5, 8].contains(index) {
                buttonFrame.origin.x = buttonX
                buttonFrame.origin.y += buttonFrame.size.height + spacing
            }
        }
    }
}

extension Keyboard {
    @objc
    func digitAction(_ sender: UIButton) {
        guard let index = keypadButtons.firstIndex(of: sender) else {
            return
        }
        UIDevice.current.playInputClick()
        switch index {
        case 10:
            outputSubject.send(.digit(.zero))
        default:
            if let digit = Digit(rawValue: index + 1) {
                outputSubject.send(.digit(digit))
            }
        }
    }

    @objc
    func backspaceAction() {
        UIDevice.current.playInputClick()
        outputSubject.send(.backspace)
    }

    @objc
    func separatorAction() {
        UIDevice.current.playInputClick()
        outputSubject.send(.decimalSeparator)
    }

    @objc
    func divisionAction() {
        UIDevice.current.playInputClick()
        outputSubject.send(.arithmeticOperator(.division))
    }

    @objc
    func multiplicationAction() {
        UIDevice.current.playInputClick()
        outputSubject.send(.arithmeticOperator(.multiplication))
    }

    @objc
    func subtractionAction() {
        UIDevice.current.playInputClick()
        outputSubject.send(.arithmeticOperator(.subtraction))
    }

    @objc
    func additionAction() {
        UIDevice.current.playInputClick()
        outputSubject.send(.arithmeticOperator(.addition))
    }

    @objc
    func equalAction() {
        UIDevice.current.playInputClick()
        outputSubject.send(.equals)
    }
}

// MARK: - Sizes

private extension Keyboard {
    var calculatorPanelHeight: CGFloat {
        showsCalculator ? 44 : 0
    }

    var keyboardHeight: CGFloat {
        keypadHeight + calculatorPanelHeight
    }

    // Mimics system decimalPad keyboard height.
    var keypadHeight: CGFloat {
        if traitCollection.verticalSizeClass == .compact {
            return 162
        }
        guard let windowHeight = window?.bounds.height else {
            return 216
        }
        if windowHeight.isLessThanOrEqualTo(667) {
            return 216
        } else if windowHeight.isLessThanOrEqualTo(736) {
            return 226
        } else if windowHeight.isLessThanOrEqualTo(812) {
            return 291
        } else {
            return 301
        }
    }
}

// MARK: - UIInputViewAudioFeedback

extension Keyboard: UIInputViewAudioFeedback {
    var enableInputClicksWhenVisible: Bool {
        true
    }
}
