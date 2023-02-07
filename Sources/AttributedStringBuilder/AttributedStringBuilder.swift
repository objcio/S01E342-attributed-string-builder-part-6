import Cocoa

@resultBuilder
struct AttributedStringBuilder {
    static func buildBlock(_ components: AttributedStringConvertible...) -> some AttributedStringConvertible {
        [components]
    }

    static func buildOptional<C: AttributedStringConvertible>(_ component: C?) -> some AttributedStringConvertible {
        component.map { [$0] } ?? []
    }
}

extension AttributedStringConvertible {
    @MainActor
    func run(environment: Environment) -> NSAttributedString {
        Joined(separator: "", content: {
            self
        }).single(environment: environment)
    }
}

