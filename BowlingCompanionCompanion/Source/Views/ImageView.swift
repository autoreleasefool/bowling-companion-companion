//
//  ImageView.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-10-30.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class ImageView: UIView {
	fileprivate let imageView = UIImageView()

	enum Position {
		case left
		case center
		case right
	}

	private var widthConstraint: NSLayoutConstraint? = nil
	fileprivate var width: CGFloat = 0 {
		didSet {
			widthConstraint?.isActive = false
			widthConstraint = imageView.widthAnchor.constraint(equalToConstant: width)
			widthConstraint?.isActive = true
		}
	}

	private var heightConstraint: NSLayoutConstraint? = nil
	fileprivate var height: CGFloat = 0 {
		didSet {
			heightConstraint?.isActive = false
			heightConstraint = imageView.heightAnchor.constraint(equalToConstant: height)
			heightConstraint?.isActive = true
		}
	}

	private var positionConstraint: NSLayoutConstraint? = nil
	fileprivate var position: Position = .left {
		didSet {
			positionConstraint?.isActive = false
			switch position {
			case .left:
				positionConstraint = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
			case .right:
				positionConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
			case .center:
				positionConstraint = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
			}
			positionConstraint?.isActive = true
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = nil

		imageView.backgroundColor = nil
		imageView.translatesAutoresizingMaskIntoConstraints = false

		addSubview(imageView)
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: topAnchor),
			imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
			])
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

struct ImageState: Equatable {
	let image: UIImage
	let width: CGFloat
	let height: CGFloat
	let position: ImageView.Position
	let insets: UIEdgeInsets

	init(image: UIImage, width: CGFloat? = nil, height: CGFloat? = nil, position: ImageView.Position = .center, insets: UIEdgeInsets = .zero) {
		self.image = image
		self.width = width ?? image.size.width
		self.height = height ?? image.size.height
		self.position = position
		self.insets = insets
	}

	public static func updateView(_ view: ImageView, state: ImageState?) {
		guard let state = state else {
			view.imageView.image = nil
			return
		}

		view.imageView.image = state.image
		view.width = state.width
		view.height = state.height
		view.position = state.position
	}

	public static func ==(lhs: ImageState, rhs: ImageState) -> Bool {
		return lhs.image == rhs.image &&
			lhs.width == rhs.width &&
			lhs.height == rhs.height &&
			lhs.insets == rhs.insets &&
			lhs.position == rhs.position
	}
}

typealias ImageCell = HostCell<ImageView, ImageState, LayoutMarginsTableItemLayout>
