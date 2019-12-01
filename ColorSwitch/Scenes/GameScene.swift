//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Emily Cheroske on 11/25/19.
//  Copyright © 2019 Emily Cheroske. All rights reserved.
//

import SpriteKit

enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
    ]
}

enum SwitchState: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var colorSwitch : SKSpriteNode!
    var switchState : SwitchState = .red
    var currentColorIndex : Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score : Int = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
        spawnBall()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody!.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false // this will keep the physics body from being affected by gravity
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        
        addChild(colorSwitch)
        addChild(scoreLabel)
    }
    
    /* Need to add in the ball */
    func spawnBall() {
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        //let ball = SKSpriteNode(imageNamed: "ball")
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.colorBlendFactor = 1
        ball.name = "Ball"
        ball.zPosition = ZPositions.ball
        //ball.size = CGSize(width: 30.0, height: 30.0)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(ball)
    }
    
    /* Need to turn color switch */
    func turnColorWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        } else {
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func gameOver() {
        UserDefaults.standard.set(score, forKey: "RecentScore")
        let currentHighScore = UserDefaults.standard.integer(forKey: "HighScore")
        if(currentHighScore < score) {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        let menu = MenuScene(size: view!.bounds.size)
        view!.presentScene(menu)
    }
    
    func updateScoreLabel(_ score : Int) {
        scoreLabel.text = "\(score)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnColorWheel()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if(contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory) {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                
                if(currentColorIndex == switchState.rawValue) {
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                        ball.removeFromParent()
                        self.score += 1
                        self.updateScoreLabel(self.score)
                        self.spawnBall()
                   })
                } else {
                    gameOver()
                }
            }
        }
    }
    
}
