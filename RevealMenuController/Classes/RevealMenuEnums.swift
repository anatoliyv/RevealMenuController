//
//  RevealMenuEnums.swift
//  Pods
//
//  Created by Anatoliy Voropay on 8/31/16.
//
//

import Foundation

///
/// Text alignment inside menu items
///
/// - Parameter Left:   Text will be left aligned, image will be on the left side
/// - Parameter Center: Text will be centered, image will be placed on the left side
/// - Parameter Right:  Text will be right aligned, image will be on the right side toward text
///
public enum RevealMenuActionTextAlignment {
    case Left
    case Center
    case Right
}

///
/// Position of a menu on a screen. Each position has it's own appearance animation.
///
/// - Parameter Top:    Menu is on a top of a screen. Appearance animation is top-to-bottom.
/// - Parameter Center: Menu is on the center of a screen. Appearance animation is fade-in.
/// - Parameter Bottom: Menu is on the bottom of a screen. Appearance animation is bottom-to-top.
///
public enum RevealMenuPosition {
    case Top
    case Center
    case Bottom
}
