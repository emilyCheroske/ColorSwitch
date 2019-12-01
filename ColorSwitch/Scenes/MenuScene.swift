//
//  MenuScene.swift
//  ColorSwitch
//
//  Created by Emily Cheroske on 11/30/19.
//  Copyright © 2019 Emily Cheroske. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    let logoRadius : Double = 200.0
    
    override func didMove(to view: SKView) {
        // add logo
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        addLogo()
        addLabels()
    }
    
    func addLogo() {
        let labelNode = SKSpriteNode(imageNamed: "logo")
        labelNode.size = CGSize(width: logoRadius, height: logoRadius)
        labelNode.position = CGPoint(x: frame.midX, y: frame.midY + frame.midY/2)
        
        addChild(labelNode)
    }
    
    func addLabels() {
        let labelMargin : CGFloat = 50.0
        
        let playLabel = SKLabelNode(text: "Tap to Play")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        playLabel.fontSize = 60
        
        let highScoreValue = UserDefaults.standard.integer(forKey: "HighScore")
        let highScoreLabel = SKLabelNode(text: "High Score: \(highScoreValue)")
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - CGFloat(logoRadius) - (labelMargin * 2))
        
       
        let recentScoreValue = UserDefaults.standard.integer(forKey: "RecentScore")
        let recentScoreLabel = SKLabelNode(text: "Recent Score: \(recentScoreValue)")
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - CGFloat(logoRadius) - (labelMargin * 3))
        
        addChild(playLabel)
        addChild(highScoreLabel)
        addChild(recentScoreLabel)
        
        animateLabel(label: playLabel)
    }
    
    func animateLabel(label : SKLabelNode) {
        //let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        //let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
}
