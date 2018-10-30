//
//  PaddedLabel.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-30.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {
	var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

	public override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: padding))
	}

	public override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		return CGSize(width: size.width + padding.left + padding.right,
					  height: size.height + padding.top + padding.bottom)
	}
}
