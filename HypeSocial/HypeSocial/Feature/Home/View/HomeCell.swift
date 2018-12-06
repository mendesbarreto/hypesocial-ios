//
// Created by Douglas Mendes on 2018-12-04.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit
import FoldingCell

final class HomeCell: FoldingCell {

    private let rotatedView = RotatedView()
    private let textView = UIView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        foregroundView = rotatedView
        contentView.addSubview(rotatedView)
        contentView.addSubview(textView)

        rotatedView
                .startAnchor()
                .leadingAnchor(to: contentView, constant: 8)
                .trailingAnchor(to: contentView, constant: -8)
                .heightAnchor(constant: 75)

        let rotatedViewConstraint = rotatedView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8)
        rotatedViewConstraint.isActive = true
        foregroundViewTop = rotatedViewConstraint

        textView.startAnchor()
                .leadingAnchor(to: contentView, constant: 8)
                .trailingAnchor(to: contentView, constant: -8)
                .heightAnchor(constant: 456)

        let textViewConstraint = rotatedView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8)
        textViewConstraint.isActive = true

        containerViewTop = textViewConstraint
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func animationDuration(itemIndex:NSInteger, type:AnimationType) -> TimeInterval {
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
}
