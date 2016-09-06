//
//  RevealMenuAction.swift
//  Pods
//
//  Created by Anatoliy Voropay on 8/31/16.
//
//

import Foundation

///
/// Basic Reveal Menu action. When selecting this item in a menu completion get called
/// with `RevealControllerHandler` block
///
/// - Seealso: `RevealControllerHandler`
///
public class RevealMenuAction: RevealMenuActionProtocol {

    public typealias RevealControllerHandler = ((RevealMenuController, RevealMenuAction) -> Void)

    /// Title for action
    public private(set) var title: String?

    /// Text alignment. Default is `Center`
    public private(set) var alignment: NSTextAlignment

    /// Label icon image
    public private(set) var image: UIImage?

    /// Selection handler
    public private(set) var handler: RevealControllerHandler?

    // MARK: Lifecycle

    ///
    /// Initialize action with all possible properties.
    ///
    /// - Parameter title:      Menu title. Required.
    /// - Parameter image:      Image icon that will be displayed beside a title. Optional.
    /// - Parameter alignment:  Text alignment inside a menu cell.
    /// - Parameter handler:    Handler will be called right after menu item is pressed.
    ///
    public required init(title: String, image: UIImage?, alignment: NSTextAlignment, handler: RevealControllerHandler?) {
        self.title = title
        self.image = image
        self.alignment = alignment
        self.handler = handler
    }

    ///
    /// Initialize action with title, image and selection handler. Default text alignment is `Center`
    ///
    /// - Parameter title:      Menu title. Required.
    /// - Parameter image:      Image icon that will be displayed beside a title. Optional.
    /// - Parameter handler:    Handler will be called right after menu item is pressed.
    ///
    public convenience init(title: String, image: UIImage?, handler: RevealControllerHandler?) {
        self.init(title: title, image: image, alignment: .center, handler: handler)
    }

    ///
    /// Initialize action title, text alignment and selection handler. 
    /// Menu item will not have any icon image.
    ///
    /// - Parameter title:      Menu title. Required.
    /// - Parameter alignment:  Text alignment inside a menu cell.
    /// - Parameter handler:    Handler will be called right after menu item is pressed.
    ///
    public convenience init(title: String, alignment: NSTextAlignment, handler: RevealControllerHandler?) {
        self.init(title: title, image: nil, alignment: alignment, handler: handler)
    }

    ///
    /// Initialize action with title and selection handler. 
    /// Menu item will have no image and text alignment is set to default value.
    ///
    /// - Parameter title:      Menu title. Required.
    /// - Parameter handler:    Handler will be called right after menu item is pressed.
    ///
    public convenience init(title: String, handler: RevealControllerHandler?) {
        self.init(title: title, image: nil, alignment: .center, handler: handler)
    }
}

///
/// Use `RevealMenuActionGroup` to group few `RevealMenuAction`s in one menu item.
/// Group shoul have it's own `title`, `image` and `alignment`.
///
/// - Seealso: `RevealMenuAction`
///
public class RevealMenuActionGroup: RevealMenuActionProtocol {

    /// Title for action group
    public private(set) var title: String?

    /// Label icon image
    public private(set) var image: UIImage?

    /// Text alignment. Default value is `Center`
    public private(set) var alignment: NSTextAlignment

    /// Array of actions inside a group
    /// - Seealso: `RevealMenuAction`
    public private(set) var actions: [RevealMenuAction] = []

    ///
    /// Initialize action group with title, image, text alignment and array of actions.
    ///
    /// - Parameter title:      Title for an action group. Required.
    /// - Parameter image:      Image that will be displayed with a title.
    /// - Parameter alignment:  Text alignment inside a menu item cell
    /// - Parameter actions:    Array of actions that will be displayed once user tap on current action group.
    ///
    public required init(title: String, image: UIImage?, alignment: NSTextAlignment, actions: [RevealMenuAction]) {
        self.title = title
        self.image = image
        self.alignment = alignment
        self.actions = actions
    }

    ///
    /// Initialize action group with title, text alignment and array of actions.
    /// Menu item will have no image.
    ///
    /// - Parameter title:      Title for an action group. Required.
    /// - Parameter alignment:  Text alignment inside a menu item cell
    /// - Parameter actions:    Array of actions that will be displayed once user tap on current action group.
    ///
    public convenience init(title: String, alignment: NSTextAlignment, actions: [RevealMenuAction]) {
        self.init(title: title, image: nil, alignment: alignment, actions: actions)
    }

    ///
    /// Initialize action group with title, image and array of actions. 
    /// Text alignment will be set to default value
    ///
    /// - Parameter title:      Title for an action group. Required.
    /// - Parameter image:      Image that will be displayed with a title.
    /// - Parameter actions:    Array of actions that will be displayed once user tap on current action group.
    ///
    public convenience init(title: String, image: UIImage, actions: [RevealMenuAction]) {
        self.init(title: title, image: image, alignment: .center, actions: actions)
    }

    ///
    /// Initialize action group with title and array of actions.
    /// Menu item will have no image and text alignment will be set to default value.
    ///
    /// - Parameter title:      Title for an action group. Required.
    /// - Parameter actions:    Array of actions that will be displayed once user tap on current action group.
    ///
    public convenience init(title: String, actions: [RevealMenuAction]) {
        self.init(title: title, image: nil, alignment: .center, actions: actions)
    }
}
