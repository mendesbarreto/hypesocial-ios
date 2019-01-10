//
// Created by Douglas Mendes on 2019-01-09.
// Copyright (c) 2019 Douglas Mendes. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class UIActivityIndicatorViewController: UIViewController, NVActivityIndicatorViewable{
    func showLoading(withMessage message: String = "") {
        let activityData = ActivityData(message: message, type: .ballScaleRippleMultiple)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }

    func update(loadingMessage: String) {
        NVActivityIndicatorPresenter.sharedInstance.setMessage(loadingMessage)
    }

    func dismissLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}
