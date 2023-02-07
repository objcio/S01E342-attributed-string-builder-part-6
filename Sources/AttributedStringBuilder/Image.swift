import Cocoa

extension NSImage: AttributedStringConvertible {
    @MainActor
    func attributedString(environment: Environment) -> [NSAttributedString] {
        let attachment = NSTextAttachment()
        attachment.image = self
        return [
            .init(attachment: attachment)
        ]
    }
}
