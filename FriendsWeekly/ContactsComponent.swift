import Contacts
import HotwireNative
import UIKit

/// Finds friends from the phone's contacts. Web sends "status" to see if
/// contacts access was already allowed, and "lookup" to ask for access and get
/// every phone number in the contacts. Only phone numbers are read. The web
/// sends them to the server once to look up friends; they're never stored.
class ContactsComponent: BridgeComponent {
    override nonisolated class var name: String { "contacts" }

    override func onReceive(message: Message) {
        switch message.event {
            case "status": replyWithStatus()
            case "lookup": lookup()
            case "openSettings": openSettings()
            default: print("ContactsComponent", "Unknown event for message: \(message)")
        }
    }

    private func replyWithStatus() {
        reply(to: "status", with: Status(status: Self.status))
    }

    private func lookup() {
        if Self.hasAccess {
            replyWithPhoneNumbers()
        } else if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            CNContactStore().requestAccess(for: .contacts) { [weak self] granted, _ in
                Task { @MainActor in
                    if granted { self?.replyWithPhoneNumbers() } else { self?.replyDenied() }
                }
            }
        } else {
            replyDenied()
        }
    }

    private func replyWithPhoneNumbers() {
        Task {
            let phoneNumbers = await Self.readPhoneNumbers()
            _ = try? await reply(to: "lookup", with: Lookup(status: "authorized", phoneNumbers: phoneNumbers))
        }
    }

    private func replyDenied() {
        reply(to: "lookup", with: Lookup(status: "denied", phoneNumbers: []))
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    private static var status: String {
        if hasAccess { return "authorized" }
        return CNContactStore.authorizationStatus(for: .contacts) == .notDetermined ? "notDetermined" : "denied"
    }

    /// Full access, or (iOS 18+) access to the contacts the user picked.
    private static var hasAccess: Bool {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .authorized { return true }
        if #available(iOS 18.0, *), status == .limited { return true }
        return false
    }

    /// Reads off the main thread; big address books can take a moment.
    private nonisolated static func readPhoneNumbers() async -> [String] {
        await Task.detached(priority: .userInitiated) {
            let request = CNContactFetchRequest(keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor])
            var numbers = Set<String>()
            try? CNContactStore().enumerateContacts(with: request) { contact, _ in
                for phoneNumber in contact.phoneNumbers {
                    numbers.insert(phoneNumber.value.stringValue)
                }
            }
            return Array(numbers)
        }.value
    }
}

private extension ContactsComponent {
    struct Status: Encodable {
        let status: String
    }

    struct Lookup: Encodable {
        let status: String
        let phoneNumbers: [String]
    }
}
