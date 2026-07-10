import SwiftUI
import PDFKit

struct PDFRenderer {
    static func render<V: View>(_ view: V, fileName: String) -> URL? {
        let renderer = ImageRenderer(content: view)

        renderer.proposedSize = ProposedViewSize(width: 612, height: 792)
        renderer.scale = 2

        guard let image = renderer.uiImage else {
            return nil
        }

        let pdfDocument = PDFDocument()
        let pdfPage = PDFPage(image: image)
        pdfDocument.insert(pdfPage!, at: 0)

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(fileName)

        if pdfDocument.write(to: url) {
            return url
        }

        return nil
    }
}
