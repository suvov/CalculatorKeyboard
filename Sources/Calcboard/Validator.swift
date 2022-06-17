import Foundation

struct Validator {
    func isValidDecimalString(_ string: String) -> Bool {
        let floatPattern = "^([0]|[(1-9)]+([(0-9)]+)?)([.][0-9]{1,2})?$"
        return validateString(string, withPattern: floatPattern)
    }
    
    func isValidPartialDecimalString(_ string: String) -> Bool {
        let partialFloatPattern = "^([0]|([(1-9)]+)([(0-9)]+)?)([.]([0-9]{1,2})?)?$"
        return validateString(string, withPattern: partialFloatPattern)
    }
}

private extension Validator {
    func validateString(_ string: String, withPattern pattern: String) -> Bool {
        if string.isEmpty { return false }
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let numMatches = regex.numberOfMatches(
                in: string,
                options: [],
                range: NSRange(location: 0, length: string.count)
            )
            return numMatches == 1
        } catch {
            return false
        }
    }
}
