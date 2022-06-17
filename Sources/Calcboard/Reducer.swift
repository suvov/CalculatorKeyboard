import Foundation

struct Reducer {
    private let validator: Validator
    private let evaluator: Evaluator
    
    init(validator: Validator, evaluator: Evaluator) {
        self.validator = validator
        self.evaluator = evaluator
    }

    func reduce(_ expression: Expression, with keyboardInput: Input) -> Expression {
        .empty
    }
}
