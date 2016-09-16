//
//  ViewController.swift
//  RevealMenuController
//
//  Created by Anatoliy Voropay on 08/31/2016.
//  Copyright (c) 2016 Anatoliy Voropay. All rights reserved.
//
import UIKit
import RevealMenuController

class ViewController: UIViewController {

    @IBAction func presentActionScheet(_ sender: AnyObject) {
        let position: RevealMenuPosition = ( sender.tag == 0 ? .top : ( sender.tag == 1 ? .center : .bottom ))
        let revealController = RevealMenuController(title: "Contact Support", position: position)
        let webImage = UIImage(named: "IconHome")
        let emailImage = UIImage(named: "IconEmail")
        let phoneImage = UIImage(named: "IconCall")

        let webAction = RevealMenuAction(title: "Open web page", image: webImage, handler: { (controller, action) in
            print(action.title)
            controller.dismiss(animated: true, completion: nil)
        })
        revealController.addAction(webAction)

        // Add first group
        let techGroup = RevealMenuActionGroup(title: "Contact tech. support", actions: [
            RevealMenuAction(title: "tech.support@apple.com", image: emailImage, handler: { (controller, action) in
                print(action.title)
            }),
            RevealMenuAction(title: "1-866-752-7753", image: phoneImage, handler: { (controller, action) in
                print(action.title)
            })
            ])
        revealController.addAction(techGroup)

        // Add second group
        let customersGroup = RevealMenuActionGroup(title: "Contact custommers support", actions: [
            RevealMenuAction(title: "customers@apple.com", image: emailImage, handler: { (controller, action) in
                print(action.title)
            }),
            RevealMenuAction(title: "1-800-676-2775", image: phoneImage, handler: { (controller, action) in
                print(action.title)
            })
            ])
        revealController.addAction(customersGroup)
        
        // Display controller
        revealController.displayOnController(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

