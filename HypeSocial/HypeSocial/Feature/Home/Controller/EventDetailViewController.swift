//
// Created by Douglas Mendes on 2018-12-09.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit

final class EventDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapInsideSubscribe(_ sender: Any) {
        showAlertWith(message: "You are subscribed for this event")
    }
    
    @IBAction func didTapInsideUnSubscribe(_ sender: Any) {
        showAlertWith(message:  "You are unsubscribed for this event")
    }

    private func showAlertWith(message: String) {
        let alertViewController = UIAlertController(title: "About us Event", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default)
        alertViewController.addAction(okAlertAction)
        present(alertViewController, animated: true)


    }
}
