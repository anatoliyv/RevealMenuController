//
//  RevealMenuCells.swift
//  Pods
//
//  Created by Anatoliy Voropay on 8/31/16.
//
//

import UIKit
import SMIconLabel

/// Cell used to display menu item actions, action groups and Cancel item.
///
/// - Seealso: `RevealMenuAction`, `RevealMenuActionGroup`
open class RevealMenuCell: UITableViewCell {
    @IBOutlet private var titleLabel: SMIconLabel!
    /// Delegate to support `RevealMenuCellDelegate` events
    open weak var delegate: RevealMenuCellDelegate?

    private struct Constants {
        static let CorenerRadius = CGFloat(8)
        static let ImagePadding  = CGFloat(5)
    }

    private enum CustomizationFor {
        case action
        case actionGroup
        case cancel
    }

    private var item: RevealMenuActionProtocol?
    private var customizedFor: CustomizationFor?
    private var topCornered: Bool = true
    private var bottomCornered: Bool = true

    // MARK: - Lifecycle

    open override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.textColor = tintColor
        titleLabel.iconPadding = Constants.ImagePadding
        titleLabel.numberOfLines = 1
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(pressedBackground(_:)))
        addGestureRecognizer(recognizer)
    }

    // MARK: - Customization

    open func customizeFor(action: RevealMenuAction) {
        self.item = action
        customizedFor = .action
        customize(
            action.title, textAlignment: action.alignment,
            font: UIFont.systemFont(ofSize: 18), image: action.image,
            imagePosition: ( action.alignment == .right ? .right : .left ))
    }

    open func customizeFor(actionGroup: RevealMenuActionGroup) {
        self.item = actionGroup
        customizedFor = .actionGroup
        customize(
            actionGroup.title, textAlignment: actionGroup.alignment,
            font: UIFont.boldSystemFont(ofSize: 18), image: actionGroup.image,
            imagePosition: ( actionGroup.alignment == .right ? .right : .left ))
    }

    open func customizeForCancel() {
        customizedFor = .cancel
        customize(
            NSLocalizedString("Cancel", comment: ""), textAlignment: .center,
            font: UIFont.boldSystemFont(ofSize: 18), image: nil,
            imagePosition: .right)
    }

    private func customize(
        _ title: String?, textAlignment: NSTextAlignment, font: UIFont,
        image: UIImage?, imagePosition: SMIconLabel.HorizontalPosition) {
        titleLabel.text = title
        titleLabel.textAlignment = textAlignment
        titleLabel.font = font
        titleLabel.icon = image
        titleLabel.iconPosition = ( imagePosition, .center )
    }

    // MARK: Round corners

    open override func layoutSubviews() {
        super.layoutSubviews()
        customizeCorners(topCornered: topCornered, bottomCornered: bottomCornered)
    }

    open func customizeCorners(topCornered top: Bool, bottomCornered bottom: Bool) {
        self.topCornered = top
        self.bottomCornered = bottom
        var corners: UIRectCorner = []
        if top {
            corners = [.topRight, .topLeft]
        }
        if bottom {
            corners = [.bottomRight, .bottomLeft]
        }
        if top && bottom {
            corners = [.topRight, .topLeft, .bottomRight, .bottomLeft]
        }
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: Constants.CorenerRadius, height: Constants.CorenerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.shouldRasterize = true
        maskLayer.rasterizationScale = UIScreen.main.scale
        layer.mask = maskLayer
    }

    open override func prepareForReuse() {
        item = nil
        titleLabel.icon = nil
        customizedFor = nil
        super.prepareForReuse()
    }

    // MARK: - Actions

    @IBAction func pressedBackground(_ sender: AnyObject?) {
        guard let customizedFor = customizedFor else { return }
        switch customizedFor {
        case .action:
            delegate?.revealMenuCell(self, didPressedWithItem: item as! RevealMenuAction)
        case .actionGroup:
            delegate?.revealMenuCell(self, didPressedWithItem: item as! RevealMenuActionGroup)
        case .cancel:
            delegate?.revealMenuCellDidPressedCancel(self)
        }
    }
}
