import HotwireNative
import UIKit

class AuthenticationComponent: BridgeComponent {
    override nonisolated class var name: String { "authentication" }

    override func onReceive(message: Message) {
        switch message.event {
            case "signedIn": sceneDelegate?.signedIn()
            case "signedOut": sceneDelegate?.signedOut()
            default: print("AuthenticationComponent", "Unknown event for message: \(message)")
        }
    }

    private var viewController: UIViewController? {
        delegate?.destination as? UIViewController
    }

    private var sceneDelegate: SceneDelegate? {
        viewController?.view.window?.windowScene?.delegate as? SceneDelegate
    }
}
