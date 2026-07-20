import HotwireNative
import UIKit

enum Tab {
    static let all = [
        HotwireTab(
            title: "Mailbox",
            image: UIImage(systemName: "rectangle.stack")!,
            url: Env.baseURL.appending(path: "newsletters")
        ),
        HotwireTab(
            title: "Post",
            image: UIImage(systemName: "square.and.pencil")!,
            url: Env.baseURL
        ),
        HotwireTab(
            title: "Friends",
            image: UIImage(systemName: "person.2")!,
            url: Env.baseURL.appending(path: "friends")
        )
    ]
}


