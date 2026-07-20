import HotwireNative
import UIKit

enum Tab {
    static let all = [
        HotwireTab(
            title: "Mailbox",
            image: UIImage(systemName: "envelope.stack")!,
            url: Env.baseURL.appending(path: "newsletters")
        ),
        HotwireTab(
            title: "Post",
            image: UIImage(systemName: "plus.app")!,
            url: Env.baseURL
        ),
        HotwireTab(
            title: "Friends",
            image: UIImage(systemName: "person.2")!,
            url: Env.baseURL.appending(path: "friends")
        )
    ]
}


