import Cocoa

struct Attributes {
    var family: String = "Helvetica"
    var size: CGFloat = 14
    var traits: NSFontTraitMask = []
    var weight = 5
    var foregroundColor: NSColor = .black
    var lineHeightMultiple: CGFloat = 1.2
    var paragraphSpacing: CGFloat = 10

    var bold: Bool {
        get { traits.contains(.boldFontMask) }
        set {
            if newValue {
                traits.insert(.boldFontMask)
            } else {
                traits.remove(.boldFontMask)
            }
        }
    }

    var italic: Bool {
        get { traits.contains(.italicFontMask) }
        set {
            if newValue {
                traits.insert(.italicFontMask)
            } else {
                traits.remove(.italicFontMask)
            }
        }
    }

    var dict: [NSAttributedString.Key: Any] {
        let fm = NSFontManager.shared
        let font = fm.font(withFamily: family, traits: traits, weight: weight, size: size)!
        let ps = NSMutableParagraphStyle()
        ps.lineHeightMultiple = lineHeightMultiple
        ps.paragraphSpacing = paragraphSpacing
        return [
            .font: font,
            .foregroundColor: foregroundColor,
            .paragraphStyle: ps
        ]
    }
}

struct Modify: AttributedStringConvertible {
    var modify: (inout Attributes) -> ()
    var contents: AttributedStringConvertible

    func attributedString(environment: Environment) -> [NSAttributedString] {
        var copy = environment
        modify(&copy.attributes)
        return contents.attributedString(environment: copy)
    }
}

extension AttributedStringConvertible {
    func bold() -> some AttributedStringConvertible {
        Modify(modify: { $0.bold = true }, contents: self)
    }

    func foregroundColor(_ color: NSColor) -> some AttributedStringConvertible {
        Modify(modify: { $0.foregroundColor = color }, contents: self)
    }
}

