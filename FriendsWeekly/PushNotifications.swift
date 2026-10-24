import UIKit
import UserNotifications

/// Asks for push permission (only once, the first time a signed in page asks),
/// hands back the APNs token so the web can save it, and opens tapped notifications.
final class PushNotifications: NSObject {
    static let shared = PushNotifications()

    /// Set by the SceneDelegate to open a tapped notification's URL
    var openURL: ((URL) -> Void)? {
        didSet { openPendingURL() }
    }

    private var token: String?
    private var tokenHandlers: [(String) -> Void] = []
    private var pendingURL: URL?

    /// Calls completion with the device token once push is allowed.
    /// Asks for permission if it hasn't been asked before; does nothing if it was denied.
    func register(completion: @escaping (String) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    if granted { self.registerForToken(completion) }
                }
            case .authorized, .provisional, .ephemeral:
                self.registerForToken(completion)
            default:
                break
            }
        }
    }

    func didRegister(deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        self.token = token
        tokenHandlers.forEach { $0(token) }
        tokenHandlers.removeAll()
    }

    func didFailToRegister(error: Error) {
        print("PushNotifications", "Failed to register: \(error)")
        tokenHandlers.removeAll()
    }

    private func registerForToken(_ completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            if let token = self.token {
                completion(token)
            } else {
                self.tokenHandlers.append(completion)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    private func openPendingURL() {
        guard let url = pendingURL, let openURL else { return }
        pendingURL = nil
        openURL(url)
    }
}

extension PushNotifications: UNUserNotificationCenterDelegate {
    /// Show notifications while the app is open too
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }

    /// Open the notification's path when it's tapped
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        guard let path = response.notification.request.content.userInfo["path"] as? String,
              let url = URL(string: path, relativeTo: Env.baseURL)?.absoluteURL else { return }

        DispatchQueue.main.async {
            // On a cold launch the scene may not be ready yet, so hold on to it
            self.pendingURL = url
            self.openPendingURL()
        }
    }
}
