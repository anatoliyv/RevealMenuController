//
//  RevealMenuCells.swift
//  Pods
//
//  Created by Anatoliy Voropay on 8/31/16.
//
//

import UIKit
import SMIconLabel

///
/// Cell used to display menu item actions, action groups and Cancel item.
///
/// - Seealso: `RevealMenuAction`, `RevealMenuActionGroup`
///
public class RevealMenuCell: UITableViewCell {

    @IBOutlet var titleLabel: SMIconLabel!

    /// Delegate to support `RevealMenuCellDelegate` events
    public weak var delegate: RevealMenuCellDelegate?

    private struct Constants {
        static let CorenerRadius = CGFloat(8)
        static let ImagePadding  = CGFloat(5)
    }

    private enum CustomizationFor {
        case Action
        case ActionGroup
        case Cancel
    }

    private var item: RevealMenuActionProtocol?
    private var customizedFor: CustomizationFor?

    // MARK: Lifecycle

    public override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .None
        titleLabel.textColor = tintColor
        titleLabel.iconPadding = Constants.ImagePadding
        titleLabel.numberOfLines = 1

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(pressedBackground(_:)))
        addGestureRecognizer(recognizer)
    }

    // MARK: Customization

    public func customizeFor(action action: RevealMenuAction) {
        self.item = action
        customizedFor = .Action

        customize(action.title, textAlignment: action.alignment,
                  font: UIFont.systemFontOfSize(18), image: action.image,
                  imagePosition: ( action.alignment == .Right ? .Right : .Left ))
    }

    public func customizeFor(actionGroup actionGroup: RevealMenuActionGroup) {
        self.item = actionGroup
        customizedFor = .ActionGroup

        customize(actionGroup.title, textAlignment: actionGroup.alignment,
                  font: UIFont.boldSystemFontOfSize(18), image: actionGroup.image,
                  imagePosition: ( actionGroup.alignment == .Right ? .Right : .Left ))
    }

    public func customizeForCancel() {
        customizedFor = .Cancel
        customize(NSLocalizedString("Cancel", comment: ""), textAlignment: .Center,
                  font: UIFont.boldSystemFontOfSize(18), image: nil,
                  imagePosition: .Right)
    }

    private func customize(title: String?, textAlignment: NSTextAlignment, font: UIFont, image: UIImage?, imagePosition: SMIconLabelPosition) {
        titleLabel.text = title
        titleLabel.textAlignment = textAlignment
        titleLabel.font = font
        titleLabel.icon = image
        titleLabel.iconPosition = imagePosition
    }

    // MARK: Round corners

    public func customizeCorners(topCornered top: Bool, bottomCornered bottom: Bool) {
        var corners: UIRectCorner = []

        if top { corners = [ .TopRight, .TopLeft ] }
        if bottom { corners = [ .BottomRight, .BottomLeft ] }
        if top && bottom { corners = [ .TopRight, .TopLeft, .BottomRight, .BottomLeft ] }

        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSizeMake(Constants.CorenerRadius, Constants.CorenerRadius))

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
        maskLayer.shouldRasterize = true
        maskLayer.rasterizationScale = UIScreen.mainScreen().scale

        layer.mask = maskLayer
    }

    public override func prepareForReuse() {
        item = nil
        titleLabel.icon = nil
        customizedFor = nil

        super.prepareForReuse()
    }

    // MARK: Actions

    @IBAction func pressedBackground(sender: AnyObject?) {
        guard let customizedFor = customizedFor else { return }

        switch customizedFor {
        case .Action:
            delegate?.revealMenuCell(self, didPressedWithItem: item as! RevealMenuAction)

        case .ActionGroup:
            delegate?.revealMenuCell(self, didPressedWithItem: item as! RevealMenuActionGroup)

        case .Cancel:
            delegate?.revealMenuCellDidPressedCancel(self)
        }
    }
}
