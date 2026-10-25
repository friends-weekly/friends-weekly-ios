import HotwireNative
import UIKit

/// Web sends "share" from an in-page invite button. Presents the native
/// share sheet with the invite text and link.
class ShareSheetComponent: BridgeComponent {
    override nonisolated class var name: String { "share-sheet" }

    override func onReceive(message: Message) {
        switch message.event {
            case "share": share(message: message)
            default: print("ShareSheetComponent", "Unknown event for message: \(message)")
        }
    }

    private func share(message: Message) {
        guard let viewController, let data: ShareData = message.data() else { return }

        var items: [Any] = [data.text]
        if let url = URL(string: data.url) { items.append(url) }

        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        viewController.present(activityViewController, animated: true)
    }

    private var viewController: UIViewController? {
        delegate?.destination as? UIViewController
    }
}

private extension ShareSheetComponent {
    struct ShareData: Decodable {
        let url: String
        let text: String
    }
}
