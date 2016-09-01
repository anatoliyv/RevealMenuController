//
//  ActionSheetController.swift
//  Pods
//
//  Created by Anatoliy Voropay on 8/30/16.
//

import UIKit

///
/// Controller used to display list of items similar to ActionScheet style in `UIAlertController`. 
/// Main purpose is to have possibility to group elements and support image icons besides
/// menu item text.
///
/// Basic usage example:
///
/// ```
/// let revealController = RevealMenuController(title: "Contact Support", position: .Center)
/// let webImage = UIImage(named: "IconHome")
/// let emailImage = UIImage(named: "IconEmail")
/// let phoneImage = UIImage(named: "IconCall")
///
/// let webAction = RevealMenuAction(title: "Open web page", image: webImage, handler: { (controller, action) in })
/// revealController.addAction(webAction)
///
/// // Add first group
/// let techGroup = RevealMenuActionGroup(title: "Contact tech. support", actions: [
///     RevealMenuAction(title: "tech.support@apple.com", image: emailImage, handler: { (controller, action) in }),
///     RevealMenuAction(title: "1-866-752-7753", image: phoneImage, handler: { (controller, action) in })
/// ])
/// revealController.addAction(techGroup)
///
/// // Add second group
/// let customersGroup = RevealMenuActionGroup(title: "Contact custommers support", actions: [
///     RevealMenuAction(title: "customers@apple.com", image: emailImage, handler: { (controller, action) in }),
///     RevealMenuAction(title: "1-800-676-2775", image: phoneImage, handler: { (controller, action) in })
/// ])
/// revealController.addAction(customersGroup)
///
/// // Display controller
/// revealController.displayOnController(self)
/// ```
///
public class RevealMenuController: UIViewController {

    /// Position of a menu. Default is `Bottom`
    public var position: RevealMenuPosition = .Bottom

    /// If `true` cancel menu item will exists in a bottom of a list.
    /// Default value is `true`
    public var displayCancel: Bool = true

    /// If `true` controller will hide if tap outside of items area.
    /// Default value is `true`
    public var hideOnBackgorundTap: Bool = true

    /// Default status bar style
    public var statusBarStyle: UIStatusBarStyle = .LightContent

    private struct Constants {
        static let CellIdentifier = "RevealMenuCell"
        static let SideMargin = CGFloat(20)
        static let CellHeight = CGFloat(44)
    }

    ///
    /// Actions and/or ActionGgroups that will be displayed.
    ///
    /// - Seealso: `RevealMenuAction`, `RevealMenuActionGroup`
    ///
    private var items: [RevealMenuActionProtocol] = []
    private var openedItems: [RevealMenuActionGroup] = []

    /// Representation of active menu items array containing opened groups and
    /// other actions.
    private var itemsList: [RevealMenuActionProtocol] {
        var list: [RevealMenuActionProtocol] = []

        for item in items {
            if let action = item as? RevealMenuAction {
                list.append(action)
            } else if let actionGroup = item as? RevealMenuActionGroup {
                list.append(actionGroup)

                if openedItems.filter({ $0 === actionGroup}).count > 0 {
                    list.appendContentsOf(actionGroup.actions.map({ (action) -> RevealMenuAction in
                        return action
                    }))
                }
            }
        }

        return list
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .Plain)
        tableView.separatorStyle = .None
        tableView.backgroundColor = .clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: Lifecycle

    public init(title: String?, position: RevealMenuPosition) {
        super.init(nibName: nil, bundle: nil)

        self.title = title
        self.position = position
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clearColor()
        registerNibWithName(Constants.CellIdentifier)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(pressedBackground(_:)))
        view.addGestureRecognizer(recognizer)
    }

    private func registerNibWithName(name: String) {
        let cellNibItem = UINib(nibName: name, bundle: NSBundle(forClass: RevealMenuController.self))
        tableView.registerNib(cellNibItem, forCellReuseIdentifier: name)
    }

    // MARK: Adding actions

    ///
    /// Add `RevealMenuAction` or `RevealMenuActionGroup` to current actions array.
    ///
    /// - Seealso: `RevealMenuAction`, `RevealMenuActionGroup`
    ///
    public func addAction<T: RevealMenuActionProtocol>(item: T) {
        items.append(item)
    }

    // MARK: Appearance and Disappeance

    ///
    /// Display `RevealMenuController` on a controller with or without animation and completion block.
    ///
    /// - Parameter controller:     RevealMenuController will be displayed in this controller
    /// - Parameter animated:       Will have appearance animation if `true`
    /// - Parameter completion:     Gets called once appearance animation finished
    ///
    public func displayOnController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        modalPresentationStyle = .OverCurrentContext

        tableView.reloadData()
        view.addSubview(tableView)
        prepareForAnimation(true)

        controller.presentViewController(self, animated: false, completion: {
            let timeInterval = NSTimeInterval(animated ? 0.2 : 0)

            UIView.animateWithDuration(timeInterval, animations: {
                self.prepareForAnimation(false)
            }, completion: { _ in
                completion?()
            })
        })
    }

    ///
    /// Display `RevealMenuController` on a controller with or without animation.
    ///
    /// - Parameter controller:     RevealMenuController will be displayed in this controller
    /// - Parameter animated:       Will have appearance animation if `true`
    ///
    public func displayOnController(controller: UIViewController, animated: Bool) {
        displayOnController(controller, animated: animated, completion: nil)
    }

    ///
    /// Display `RevealMenuController` on a controller with appearance animation.
    ///
    /// - Parameter controller:     RevealMenuController will be displayed in this controller
    ///
    public func displayOnController(controller: UIViewController) {
        displayOnController(controller, animated: true, completion: nil)
    }

    ///
    /// Dismiss view controller with animation and completion handler.
    ///
    public override func dismissViewControllerAnimated(animated: Bool, completion: (() -> Void)?) {
        let timeInterval = NSTimeInterval(animated ? 0.2 : 0)
        prepareForAnimation(false)

        UIView.animateWithDuration(timeInterval, animations: {
            self.prepareForAnimation(true)
        }, completion: { _ in
            super.dismissViewControllerAnimated(false, completion: {
                completion?()
            })
        })
    }

    private func prepareForAnimation(initial: Bool) {
        updateTableViewFrameForCurrentSize()
        updateTableInsetsForCurrentHeight()

        tableView.alpha = ( position == .Center ? 0 : 1 )

        if initial {
            switch position {
            case .Top:      tableView.frame = CGRectOffset(tableView.frame, 0, -tableView.contentSize.height - Constants.SideMargin)
            case .Bottom:   tableView.frame = CGRectOffset(tableView.frame, 0, tableView.contentSize.height + Constants.SideMargin)
            case .Center:   break
            }
        } else {
            tableView.alpha = 1
        }
    }

    // MARK: Actions

    func pressedBackground(sender: AnyObject?) {
        guard hideOnBackgorundTap else { return }
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: Position table view

    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        updateTableViewFrameForSize(size)
        updateTableInsetsForHeight(size.height)
        tableView.reloadData()
    }

    private func updateTableInsetsForCurrentHeight() {
        updateTableInsetsForHeight(view.bounds.height - Constants.SideMargin * 2.5)
    }

    private func updateTableInsetsForHeight(height: CGFloat) {
        let contentHeight: CGFloat = CGFloat(itemsList.count) * Constants.CellHeight
            + ( displayCancel ? Constants.CellHeight + Constants.SideMargin / 2 : 0 )

        switch position {
        case .Top:
            tableView.contentInset = UIEdgeInsetsZero

        case .Center:
            let inset: CGFloat = max((height - contentHeight) / 2.0, 0)
            tableView.contentInset = UIEdgeInsetsMake(inset, 0, -inset, 0);

        case .Bottom:
            let inset: CGFloat = max(height - contentHeight, 0)
            tableView.contentInset = UIEdgeInsetsMake(inset, 0, 0, 0);
        }
    }

    private func updateTableViewFrameForCurrentSize() {
        updateTableViewFrameForSize(super.view.bounds.size)
    }

    private func updateTableViewFrameForSize(size: CGSize) {
        tableView.frame = CGRect(x: Constants.SideMargin, y: Constants.SideMargin,
                                 width: size.width - Constants.SideMargin * 2,
                                 height: size.height - Constants.SideMargin * 2)
    }
}

///
/// UITableViewDelegate
///
extension RevealMenuController: UITableViewDelegate {
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.CellHeight
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ( displayCancel ? Constants.SideMargin / 2 : 0 )
    }
}

///
/// UITableViewDataSource
///
extension RevealMenuController: UITableViewDataSource {

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ( displayCancel ? 2 : 1 )
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 1 }
        return itemsList.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier, forIndexPath: indexPath) as! RevealMenuCell

        if indexPath.section == 1 {
            cell.customizeForCancel()
        } else {
            let offset = indexPath.row
            if let action = itemsList[offset] as? RevealMenuAction {
                cell.customizeFor(action: action)
            } else if let actionGroup = itemsList[offset] as? RevealMenuActionGroup {
                cell.customizeFor(actionGroup: actionGroup)
            }
        }

        cell.customizeCorners(topCornered: indexPath.row == 0, bottomCornered: indexPath.section == 1 || indexPath.row == itemsList.count - 1)
        cell.delegate = self

        return cell
    }

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
}

///
/// RevealMenuCellDelegate
///
extension RevealMenuController: RevealMenuCellDelegate {

    public func revealMenuCell(cell: RevealMenuCell, didPressedWithItem item: RevealMenuActionProtocol) {
        if let action = item as? RevealMenuAction {
            action.handler?(self, action)
        } else if let
            actionGroup = item as? RevealMenuActionGroup,
            cellIndexPath = tableView.indexPathForCell(cell)
        {
            if let index = openedItems.indexOf({ $0 === actionGroup }) {
                openedItems.removeAtIndex(index)

                var deleteIndexPaths: [NSIndexPath] = []
                for index in 1...actionGroup.actions.count {
                    deleteIndexPaths.append(NSIndexPath(forRow: cellIndexPath.row + index, inSection: 0))
                }

                UIView.animateWithDuration(0.2, animations: {
                    self.tableView.beginUpdates()
                    self.tableView.reloadRowsAtIndexPaths([ cellIndexPath ], withRowAnimation: .Fade)
                    self.tableView.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Fade)
                    self.updateTableInsetsForCurrentHeight()
                    self.tableView.endUpdates()
                })
            } else {
                openedItems.append(actionGroup)

                var insertIndexPaths: [NSIndexPath] = []
                for index in 1...actionGroup.actions.count {
                    insertIndexPaths.append(NSIndexPath(forRow: cellIndexPath.row + index, inSection: 0))
                }

                UIView.animateWithDuration(0.2, animations: {
                    self.tableView.beginUpdates()
                    self.tableView.reloadRowsAtIndexPaths([ cellIndexPath ], withRowAnimation: .Fade)
                    self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Fade)
                    self.updateTableInsetsForCurrentHeight()
                    self.tableView.endUpdates()
                })
            }
        } else {
            tableView.reloadData()
            updateTableInsetsForCurrentHeight()
        }
    }

    public func revealMenuCellDidPressedCancel(cell: RevealMenuCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

///
/// Status bar
///
extension RevealMenuController {

    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }
}
