//
//  RevealMenuAction.swift
//  Pods
//
//  Created by Anatoliy Voropay on 8/31/16.
//
//

import Foundation

/// Basic Reveal Menu action. When selecting this item in a menu completion get called
/// with `RevealControllerHandler` block
///
/// - Seealso: `RevealControllerHandler`
open class RevealMenuAction: RevealMenuActionProtocol {
    /// Text alignment inside menu items
    ///
    /// - Parameter left:   Text will be left aligned, image will be on the left side
    /// - Parameter center: Text will be centered, image will be placed on the left side
    /// - Parameter right:  Text will be right aligned, image will be on the right side toward text
    public enum TextAlignment {
        case left
        case center
        case right
    }

    public typealias RevealControllerHandler = ((RevealMenuController, RevealMenuAction) -> Void)

    /// Title for action
    open private(set) var title: String?
    /// Text alignment. Default is `Center`
    open private(set) var alignment: NSTextAlignment
    /// Label icon image
    open private(set) var image: UIImage?
    /// Selection handler
    open private(set) var handler: RevealControllerHandler?

    // MARK: - Lifecycle

    /// Initialize action with all possible properties.
    ///
    /// - Parameter title:      Menu title. Required.
    /// - Parameter image:      Image icon that will be displayed beside a title. Optional.
    /// - Parameter alignment:  Text alignment inside a menu cell.
    /// - Parameter handler:    Handler will be called right after menu item is pressed.
    public required init(
        title: String, image: UIImage? = nil,
        alignment: NSTextAlignment = .center, handler: RevealControllerHandler?) {
        self.title = title
        self.image = image
        self.alignment = alignment
        self.handler = handler
    }
}

/// Use `RevealMenuActionGroup` to group few `RevealMenuAction`s in one menu item.
/// Group shoul have it's own `title`, `image` and `alignment`.
///
/// - Seealso: `RevealMenuAction`
open class RevealMenuActionGroup: RevealMenuActionProtocol {
    /// Title for action group
    open private(set) var title: String?
    /// Label icon image
    open private(set) var image: UIImage?
    /// Text alignment. Default value is `Center`
    open private(set) var alignment: NSTextAlignment
    /// Array of actions inside a group
    /// - Seealso: `RevealMenuAction`
    open private(set) var actions: [RevealMenuAction] = []

    /// Initialize action group with title, image, text alignment and array of actions.
    ///
    /// - Parameter title:      Title for an action group. Required.
    /// - Parameter image:      Image that will be displayed with a title.
    /// - Parameter alignment:  Text alignment inside a menu item cell
    /// - Parameter actions:    Array of actions that will be displayed once user tap on current action group.
    ///
    public required init(title: String, image: UIImage? = nil, alignment: NSTextAlignment = .center, actions: [RevealMenuAction]) {
        self.title = title
        self.image = image
        self.alignment = alignment
        self.actions = actions
    }
}
