#if DEBUG
import SwiftUI

struct CustomStylesheet: Stylesheet {
    func strong(attributes: inout Attributes) {
        attributes.foregroundColor = .red
    }
}

@AttributedStringBuilder
var example: some AttributedStringConvertible {
    "Hello, World!"
        .bold()
    """
    This is some markdown with **strong** text. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tempus, tortor eu maximus gravida, ante diam fermentum magna, in gravida ex tellus ac purus.

    Another *paragraph*.
    """
        .markdown(stylesheet: CustomStylesheet())
    NSImage(systemSymbolName: "hand.wave", accessibilityDescription: nil)!
    Embed(proposal: .init(width: 200, height: nil)) {
        HStack {
            Image(systemName: "hand.wave")
            Text("Hello from SwiftUI")
            Color.red.frame(width: 100, height: 50)
        }
    }    
}

let sampleAttributes = Attributes(family: "Tiempos Text", size: 20)

struct TextView: NSViewRepresentable {
    var attributedString: NSAttributedString

    func makeNSView(context: Context) -> NSTextView {
        let v = NSTextView()
        v.isEditable = false
        v.textContainer!.lineFragmentPadding = 0
        v.textContainer!.widthTracksTextView = false
        v.drawsBackground = true
        v.backgroundColor = .white
        return v
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(attributedString)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSTextView, context: Context) -> CGSize? {
        let size = proposal.replacingUnspecifiedDimensions(by: .zero)
        let c = nsView.textContainer!
        c.size = size
        nsView.layoutManager?.ensureLayout(for: c)
        return nsView.layoutManager?.usedRect(for: c).size
    }
}

struct DebugPreview: PreviewProvider {
    static var previews: some View {
        let attStr = example
            .joined()
            .run(environment: .init(attributes: sampleAttributes))
        TextView(attributedString: attStr)
            .frame(width: 400)
            .previewLayout(.sizeThatFits)
    }
}
#endif

