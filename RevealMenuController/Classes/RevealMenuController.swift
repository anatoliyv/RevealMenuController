//
//  ActionSheetController.swift
//  Pods
//
//  Created by Anatoliy Voropay on 8/30/16.
//

import UIKit

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
open class RevealMenuController: UIViewController {
    /// Position of a menu on a screen. Each position has it's own appearance animation.
    ///
    /// - Parameter top:    Menu is on a top of a screen. Appearance animation is top-to-bottom.
    /// - Parameter center: Menu is on the center of a screen. Appearance animation is fade-in.
    /// - Parameter bottom: Menu is on the bottom of a screen. Appearance animation is bottom-to-top.
    public enum Position {
        case top
        case center
        case bottom
    }

    /// Position of a menu. Default is `Bottom`
    open var position: Position = .bottom
    /// If `true` cancel menu item will exists in a bottom of a list.
    /// Default value is `true`
    open var displayCancel: Bool = true
    /// If `true` controller will hide if tap outside of items area.
    /// Default value is `true`
    open var hideOnBackgorundTap: Bool = true
    /// Default status bar style
    open var statusBarStyle: UIStatusBarStyle = .lightContent

    private struct Constants {
        static let cellIdentifier = "RevealMenuCell"
        static let sideMargin = CGFloat(20)
        static let cellHeight = CGFloat(44)
    }

    /// Actions and/or ActionGgroups that will be displayed.
    ///
    /// - Seealso: `RevealMenuAction`, `RevealMenuActionGroup`
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
                if openedItems.filter({ $0 === actionGroup }).count > 0 {
                    list.append(contentsOf: actionGroup.actions.map({ (action) -> RevealMenuAction in
                        return action
                    }))
                }
            }
        }
        return list
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: - Lifecycle

    public init(title: String?, position: Position) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.position = position
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        registerNibWithName(Constants.cellIdentifier)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(pressedBackground(_:)))
        view.addGestureRecognizer(recognizer)
    }

    private func registerNibWithName(_ name: String) {
        let cellNibItem = UINib(nibName: name, bundle: Bundle(for: RevealMenuController.self))
        tableView.register(cellNibItem, forCellReuseIdentifier: name)
    }

    // MARK: - Adding actions

    /// Add `RevealMenuAction` or `RevealMenuActionGroup` to current actions array.
    ///
    /// - Seealso: `RevealMenuAction`, `RevealMenuActionGroup`
    open func addAction<T: RevealMenuActionProtocol>(_ item: T) {
        items.append(item)
    }

    // MARK: - Appearance and Disappeance

    /// Display `RevealMenuController` on a controller with or without animation and completion block.
    ///
    /// - Parameter controller:     RevealMenuController will be displayed in this controller
    /// - Parameter animated:       Will have appearance animation if `true`
    /// - Parameter completion:     Gets called once appearance animation finished
    open func displayOnController(
        _ controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        modalPresentationStyle = .overCurrentContext
        addTableView()
        updateTableViewFrame(true)
        controller.present(
            self,
            animated: false,
            completion: {
                let timeInterval = TimeInterval(animated
                    ? 0.2
                    : 0)
                UIView.animate(withDuration: timeInterval, animations: {
                    self.updateTableViewFrame(false)
                }, completion: { _ in
                    completion?()
                })
            })
    }

    private func addTableView() {
        view.addSubview(tableView)
        tableView.reloadData()
    }

    /// Dismiss view controller with animation and completion handler.
    open override func dismiss(animated: Bool, completion: (() -> Void)?) {
        let timeInterval = TimeInterval(animated
            ? 0.2
            : 0)
        UIView.animate(
            withDuration: timeInterval,
            animations: {
                self.updateTableViewFrame(true)
            }, completion: { _ in
                super.dismiss(animated: false, completion: {
                    completion?()
                })
            })
    }

    private var contentHeight: CGFloat {
        var height: CGFloat = CGFloat(Constants.cellHeight) * CGFloat(itemsList.count)
        height += displayCancel
            ? CGFloat(Constants.cellHeight) + 10
            : 0
        return height
    }

    private func updateTableViewFrame(_ initial: Bool) {
        tableView.alpha = initial
            ? 0
            : 1
        var insets: UIEdgeInsets = .zero
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets
        }
        var width = min(view.bounds.height, view.bounds.width)
        var height = max(view.bounds.height, view.bounds.width)
        if view.bounds.height < view.bounds.width {
            (width, height) = (height, width)
        }
        let sideSpacing: CGFloat = UIDevice.current.userInterfaceIdiom == .pad
            ? width / 4
            : Constants.sideMargin
        let contentHeight = self.contentHeight
        var rect: CGRect = .zero
        switch position {
        case .top:
            rect = CGRect(
                x: sideSpacing, y: Constants.sideMargin + insets.top,
                width: width - 2 * sideSpacing, height: contentHeight)
        case .bottom:
            rect = CGRect(
                x: sideSpacing, y: height - Constants.sideMargin - insets.top - contentHeight,
                width: width - 2 * sideSpacing, height: contentHeight)
        case .center:
            rect = CGRect(
                x: sideSpacing,
                y: (height - insets.top - contentHeight) / 2,
                width: width - 2 * sideSpacing, height: contentHeight)
        }
        if initial {
            switch position {
            case .top:
                rect = rect.offsetBy(dx: 0, dy: -contentHeight)
            case .bottom:
                rect = rect.offsetBy(dx: 0, dy: contentHeight)
            case .center:
                break
            }
        }
        tableView.frame = rect
    }

    // MARK: - Actions

    @objc func pressedBackground(_ sender: AnyObject?) {
        guard hideOnBackgorundTap else { return }
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Position table view

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateTableViewFrame(false)
        }, completion: nil)
    }
}

/// `UITableViewDelegate` protocol implementation
extension RevealMenuController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else { return 0 }
        return displayCancel
            ? Constants.sideMargin / 2
            : 0
    }
}

/// `UITableViewDataSource` protocol implementation
extension RevealMenuController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return displayCancel
            ? 2
            : 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 1 }
        return itemsList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! RevealMenuCell
        if (indexPath as NSIndexPath).section == 1 {
            cell.customizeForCancel()
        } else {
            let offset = (indexPath as NSIndexPath).row
            if let action = itemsList[offset] as? RevealMenuAction {
                cell.customizeFor(action: action)
            } else if let actionGroup = itemsList[offset] as? RevealMenuActionGroup {
                cell.customizeFor(actionGroup: actionGroup)
            }
        }
        cell.customizeCorners(
            topCornered: (indexPath as NSIndexPath).row == 0,
            bottomCornered: (indexPath as NSIndexPath).section == 1 ||
                (indexPath as NSIndexPath).row == itemsList.count - 1)
        cell.delegate = self
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
}

/// `RevealMenuCellDelegate` protocol implementation
extension RevealMenuController: RevealMenuCellDelegate {
    public func revealMenuCell(_ cell: RevealMenuCell, didPressedWithItem item: RevealMenuActionProtocol) {
        if let action = item as? RevealMenuAction {
            action.handler?(self, action)
        } else if let actionGroup = item as? RevealMenuActionGroup {
            if let index = openedItems.index(where: { $0 === actionGroup }) {
                openedItems.remove(at: index)
                tableView.reloadData()
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self.updateTableViewFrame(false)
                    })
            } else {
                openedItems.append(actionGroup)
                tableView.reloadData()
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self.updateTableViewFrame(false)
                    })
            }
        } else {
            tableView.reloadData()
            updateTableViewFrame(false)
        }
    }

    public func revealMenuCellDidPressedCancel(_ cell: RevealMenuCell) {
        dismiss(animated: true, completion: nil)
    }
    
}

/// Status bar
extension RevealMenuController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
