import SwiftUI

struct ReceiptViewer: View {

    @Environment(\.dismiss) private var dismiss

    let imageData: Data

    var body: some View {

        NavigationStack {

            if let uiImage = UIImage(data: imageData) {

                ZoomableScrollView {

                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding()

                }

            }

        }
        .background(.black)
        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {

                Button("Done") {
                    dismiss()
                }

            }

        }

    }

}
