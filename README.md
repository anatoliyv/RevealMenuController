![RevealMenuController](https://cloud.githubusercontent.com/assets/1595032/18164385/37484428-7048-11e6-924d-2509b7d56131.png)

![RevealMenuController](https://travis-ci.org/anatoliyv/RevealMenuController.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/RevealMenuController.svg?style=flat)](http://cocoapods.org/pods/RevealMenuController)
[![License](https://img.shields.io/cocoapods/l/RevealMenuController.svg?style=flat)](http://cocoapods.org/pods/RevealMenuController)
[![Platform](https://img.shields.io/cocoapods/p/RevealMenuController.svg?style=flat)](http://cocoapods.org/pods/RevealMenuController)
![](https://img.shields.io/badge/Supported-iOS8-4BC51D.svg?style=flat)
![](https://img.shields.io/badge/Swift 3-compatible-4BC51D.svg?style=flat)

Easy to implement controller with expanding menu items. Design is very similar to iOS native ActionSheet presentation style of a UIAlertController. As an additional feature you can set small image icon beside menu item text. Take a look at example screenshot to see all available features.

Features:
- [x] Expandable menu groups
- [x] Custom presentation position (top, center or bottom)
- [x] Custom text alignment
- [x] Menu items can have images

Here are few screenshot with possible usage. I've added a [small video](https://github.com/anatoliyv/RevealMenuController/blob/master/Example/ExampleVideo.mov?raw=true) (~5Mb) also where you can see live example without installation and launching demo project.

![RevealMenuController](https://cloud.githubusercontent.com/assets/1595032/18165230/bf610d0a-704c-11e6-860d-747a4002fc1b.png)

## Installation

#### CocoaPods

RevealMenuController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RevealMenuController"
```

#### Cartage

Support will be added in version 1.0

## Usage

Initialize `RevealMenuController` and set required properties:

```swift
let revealController = RevealMenuController(title: "Contact Support", position: .Center)
revealController.displayCancel = true           // Display Cancel menu item
revealController.hideOnBackgorundTap = true     // Hide menu when user taps outside of items area
revealController.statusBarStyle = .LightContent // Status bar style
```

Now you can add actions to menu. Take a look at `image` property: this menu item will have small icon places beside a text.

```swift
let webImage = UIImage(named: "IconHome")
let webAction = RevealMenuAction(title: "Open web page", image: webImage, handler: { (controller, action) in
    // Code to support tap on this item
})
revealController.addAction(webAction)
```

Adding of action groups is very similar:

```swift
let emailImage = UIImage(named: "IconEmail")
let phoneImage = UIImage(named: "IconCall")
let techGroup = RevealMenuActionGroup(title: "Contact support", actions: [
    RevealMenuAction(title: "tech.support@apple.com", image: emailImage, handler: { (controller, action) in
        // Code to support tap on this item
    }),
    RevealMenuAction(title: "1-866-752-7753", image: phoneImage, handler: { (controller, action) in
        // Code to support tap on this item
    })
])
revealController.addAction(techGroup)
```

When you're ready to present controller call:

```swift
revealController.displayOnController(self)
```

Appearance animation depends on it's position:

- Top: Controller appearance will have top-to-bottom slide animation.
- Center: Appearance with fade-in animation
- Bottom: Appearance with bottom-to-top slide animation.

Disappearance will have reverse animation.

#### Dismissing

To dismiss `RevealMenuController` call next method. Collapse animation will be reversed to appearance one.

```swift
controller.dismissViewControllerAnimated(true, completion: {
    // Completion block
})
```

#### RevealMenuAction

RevealMenuAction can be initialized in few ways. Title is always required for action. Image is an optional value. Default text alignment is `Center`. Handler is also not required but if you will not specify this property there will be no response for user tap on this item.

List of initializers:

```swift
init(title: String, image: UIImage?, alignment: NSTextAlignment, handler: RevealControllerHandler?)
init(title: String, image: UIImage?, handler: RevealControllerHandler?)
init(title: String, alignment: NSTextAlignment, handler: RevealControllerHandler?)
init(title: String, handler: RevealControllerHandler?)
```

#### RevealMenuActionGroup

Action groups will keep few `RevealMenuAction`s inside. When user press on such menu item group will expand and show list of available actions. Second tap will collapse actions list.

Title is also required for action group. It can have it's own icon image and text alignment, similar to `RevealMenuAction`. The only difference is that group has no tap handler but actions array instead of it.

List of initializers:

```swift
init(title: String, image: UIImage?, alignment: NSTextAlignment, actions: [RevealMenuAction])
init(title: String, alignment: NSTextAlignment, actions: [RevealMenuAction])
init(title: String, image: UIImage, actions: [RevealMenuAction])
init(title: String, actions: [RevealMenuAction])
```

## TODO

- [ ] Custom sizes for iPad
- [ ] Menu item labels customization (font, color)
- [ ] Implement menu title
- [ ] Support for multiline items

Write me or make a pull request if you have any ideas what else functionality could be useful for `RevealMenuController`.

## Author

- anatoliy.voropay@gmail.com
- [@anatoliy_v](https://twitter.com/anatoliy_v)
- [LinkedIn](https://www.linkedin.com/in/anatoliyvoropay)

## License

`RevealMenuController` is available under the MIT license. See the LICENSE file for more info.
