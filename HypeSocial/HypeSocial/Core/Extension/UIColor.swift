//
// Created by Douglas Mendes on 2018-12-09.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int) {
        let redMask: UInt = 16
        let greenMask: UInt = 8
        let blueMask: UInt = 0
        let red = CGFloat((hex >> redMask) & 0xff) / 0xff
        let green = CGFloat((hex >> greenMask) & 0xff) / 0xff
        let blue = CGFloat((hex >> blueMask) & 0xff) / 0xff
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension UIColor {
    static var levioGreen: UIColor {
        return UIColor(hex: 0x86BB23)
    }
}

