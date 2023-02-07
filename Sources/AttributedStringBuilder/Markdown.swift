import Markdown
import Foundation

protocol Stylesheet {
    func strong(attributes: inout Attributes)
    func emphasis(attributes: inout Attributes)
}

extension Stylesheet {
    func strong(attributes: inout Attributes) {
        attributes.bold = true
    }

    func emphasis(attributes: inout Attributes) {
        attributes.italic = true
    }
}

struct DefaultStylesheet: Stylesheet { }

struct AttributedStringWalker: MarkupWalker {
    let result = NSMutableAttributedString()
    var attributes: Attributes
    var stylesheet: any Stylesheet = DefaultStylesheet()

    func visitText(_ text: Text) -> () {
        result.append(.init(string: text.string, attributes: attributes.dict))
    }

    mutating func visitDocument(_ document: Document) -> () {
        for child in document.children {
            if !result.string.isEmpty {
                result.append(.init(string: "\n", attributes: attributes.dict))
            }
            visit(child)
        }
    }

    mutating func visitStrong(_ strong: Strong) -> () {
        let copy = attributes
        defer { attributes = copy }
        stylesheet.strong(attributes: &attributes)
        descendInto(strong)
    }

    mutating func visitEmphasis(_ emphasis: Emphasis) -> () {
        let copy = attributes
        defer { attributes = copy }
        stylesheet.emphasis(attributes: &attributes)
        descendInto(emphasis)
    }
}

fileprivate struct Markdown: AttributedStringConvertible {
    var content: String
    var stylesheet: any Stylesheet

    func attributedString(environment: Environment) -> [NSAttributedString] {
        let doc = Document(parsing: content)
        var walker = AttributedStringWalker(attributes: environment.attributes, stylesheet: stylesheet)
        walker.visit(doc)
        return [walker.result]
    }
}

extension String {
    func markdown(stylesheet: any Stylesheet = DefaultStylesheet()) -> some AttributedStringConvertible {
        Markdown(content: self, stylesheet: stylesheet)
    }
}
