import Foundation

protocol AttributedStringConvertible {
    @MainActor
    func attributedString(environment: Environment) -> [NSAttributedString]
}

struct Environment {
    var attributes = Attributes()
}

extension String: AttributedStringConvertible {
    @MainActor
    func attributedString(environment: Environment) -> [NSAttributedString] {
        [.init(string: self, attributes: environment.attributes.dict)]
    }
}

extension AttributedString: AttributedStringConvertible {
    @MainActor
    func attributedString(environment: Environment) -> [NSAttributedString] {
        [.init(self)]
    }
}

extension NSAttributedString: AttributedStringConvertible {
    @MainActor
    func attributedString(environment: Environment) -> [NSAttributedString] {
        [self]
    }
}

extension Array: AttributedStringConvertible where Element == AttributedStringConvertible {
    @MainActor
    func attributedString(environment: Environment) -> [NSAttributedString] {
        flatMap { $0.attributedString(environment: environment) }
    }
}


