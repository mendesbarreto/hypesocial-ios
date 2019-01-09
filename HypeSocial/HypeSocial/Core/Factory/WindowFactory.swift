//
// Created by Douglas Mendes on 2019-01-08.
// Copyright (c) 2019 Douglas Mendes. All rights reserved.
//

import UIKit

final class WindowFactory {
    static func make() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .blue
        return window
    }
}
