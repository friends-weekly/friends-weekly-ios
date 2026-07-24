//
//  FriendsWeeklyWebViewController.swift
//  FriendsWeekly
//
//  Created by Christian Hatch on 3/28/25.
//

import UIKit
import HotwireNative

class FriendsWeeklyWebViewController: HotwireWebViewController {
	override open func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor.lightBackground
		addCloseButtonToModals()
	}

	private func addCloseButtonToModals() {
		guard presentingViewController != nil else { return }

		let action = UIAction { [unowned self] _ in
			dismiss(animated: true)
		}
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			systemItem: .close,
			primaryAction: action
		)
	}
}
