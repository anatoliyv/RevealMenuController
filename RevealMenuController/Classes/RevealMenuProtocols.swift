//
//  RevealMenuProtocols.swift
//  Pods
//
//  Created by Anatoliy Voropay on 8/31/16.
//

import Foundation
import UIKit

/// Current protocol describes basic properties for menu items.
///
/// - Seealso: `RevealMenuAction`, `RevealMenuActionGroup`
public protocol RevealMenuActionProtocol {
    /// Title for action or action group
    var title: String? { get }
    /// Text alignment
    var alignment: NSTextAlignment { get }
    /// Icon image
    var image: UIImage? { get }
}

/// Delegate to handle touch events from RevealMenuCell
///
/// - Seealso: `RevealMenuCell`
public protocol RevealMenuCellDelegate : class {
    /// RevealMenuCell did pressed event
    func revealMenuCell(_ cell: RevealMenuCell, didPressedWithItem item: RevealMenuActionProtocol)
    /// RevealMenuCell  with Cancel button pressed
    func revealMenuCellDidPressedCancel(_ cell: RevealMenuCell)
}
