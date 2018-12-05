//
// Created by Douglas Mendes on 2018-12-04.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit
import FoldingCell

final class HomeCell: FoldingCell {
    private let rotatedView = RotatedView()
    private let textView = RotatedView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        foregroundView = rotatedView
        contentView.addSubview(rotatedView)
        rotatedView
                .startAnchor()
                .topAnchor(to: contentView, constant: 8)
                .leadingAnchor(to: contentView, constant: 8)
                .trailingAnchor(to: contentView, constant: -8)
                .heightAnchor(constant: 75)

        textView = 
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
