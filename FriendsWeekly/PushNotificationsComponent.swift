import HotwireNative
import UIKit

/// Web asks to "register" on every signed in page. Replies with the device
/// token once push is allowed, so the web can save it to the server.
class PushNotificationsComponent: BridgeComponent {
    override nonisolated class var name: String { "push-notifications" }

    override func onReceive(message: Message) {
        switch message.event {
            case "register": register()
            default: print("PushNotificationsComponent", "Unknown event for message: \(message)")
        }
    }

    private func register() {
        PushNotifications.shared.register { [weak self] token in
            self?.reply(to: "register", with: Device(token: token, name: UIDevice.current.name))
        }
    }
}

private extension PushNotificationsComponent {
    struct Device: Encodable {
        let token: String
        let platform = "apple"
        let name: String
    }
}
