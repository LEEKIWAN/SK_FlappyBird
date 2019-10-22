
//
//  MenuScene.swift
//  FlappyBird
//
//  Created by kiwan on 2019/10/22.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    var background = SKSpriteNode(imageNamed: "background1")
    
    override func didMove(to view: SKView) {
        
        if arc4random() % 2 == 0 {
            background = SKSpriteNode(imageNamed: "background1")
        }
        else {
            background = SKSpriteNode(imageNamed: "background2")
        }
        
        background.anchorPoint = .zero
        
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 0
        self.addChild(background)
        
        let titleLabel = SKSpriteNode(imageNamed: "titleLabel")
        titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.7)
        titleLabel.zPosition = 1
        self.addChild(titleLabel)
        
        let playButton = SKSpriteNode(imageNamed: "playBtn")
        playButton.name = "playButton"
        playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.3)
        playButton.zPosition = 1
        self.addChild(playButton)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        let nodesArray = self.nodes(at: point)
        if nodesArray.first?.name == "playButton" {
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            gameScene.background = background
            self.view?.presentScene(gameScene)
        }
    }
    
}
