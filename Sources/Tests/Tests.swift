import XCTest
@testable import AttributedStringBuilder
import SwiftUI

@AttributedStringBuilder
var example: some AttributedStringConvertible {
    "Hello, World!"
        .bold()
    Array(repeating:
    """
    This is some markdown with **strong** text. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tempus, tortor eu maximus gravida, ante diam fermentum magna, in gravida ex tellus ac purus.

    Another *paragraph*.
    """.markdown(stylesheet: CustomStylesheet()) as any AttributedStringConvertible, count: 20)
    NSImage(systemSymbolName: "hand.wave", accessibilityDescription: nil)!
    Embed(proposal: .init(width: 200, height: nil)) {
        HStack {
            Image(systemName: "hand.wave")
            Text("Hello from SwiftUI")
            Color.red.frame(width: 100, height: 50)
        }
    }
}

let sampleAttributes = Attributes(family: "Tiempos Text", size: 16)

class Tests: XCTestCase {
    @MainActor
    func testPDF() {
        let data = example
            .joined(separator: "\n")
            .run(environment: .init(attributes: sampleAttributes))
            .pdf()
        try! data.write(to: .desktopDirectory.appending(component: "out.pdf"))
    }
}
