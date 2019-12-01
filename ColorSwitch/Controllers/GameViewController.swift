//
//  GameViewController.swift
//  ColorSwitch
//
//  Created by Emily Cheroske on 11/25/19.
//  Copyright © 2019 Emily Cheroske. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene(size: view.bounds.size)
            
            // Set the scale mode to scale to fit the window
           scene.scaleMode = .aspectFill
           
           // Present the scene
           view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
