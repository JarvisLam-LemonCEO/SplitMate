import SwiftUI

struct ZoomableScrollView<Content: View>: UIViewRepresentable {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(hostingController: UIHostingController(rootView: content))
    }

    func makeUIView(context: Context) -> UIScrollView {

        let scrollView = UIScrollView()

        scrollView.maximumZoomScale = 6
        scrollView.minimumZoomScale = 1
        scrollView.delegate = context.coordinator

        let hostedView = context.coordinator.hostingController.view!

        hostedView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(hostedView)

        NSLayoutConstraint.activate([
            hostedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostedView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostedView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.hostingController.rootView = content
    }

    class Coordinator: NSObject, UIScrollViewDelegate {

        let hostingController: UIHostingController<Content>

        init(hostingController: UIHostingController<Content>) {
            self.hostingController = hostingController
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            hostingController.view
        }

    }

}
