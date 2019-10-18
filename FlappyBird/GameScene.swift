//
//  GameScene.swift
//  FlappyBird
//
//  Created by kiwan on 2019/10/18.
//  Copyright © 2019 kiwan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        createBird()
        createEnvironment()  
    }
    
    func createBird() {
        // Animation
//        let birdTexture = SKTextureAtlas(named: "Bird")
//        var birdTextureArray: [SKTexture] = []
//        for textureName in birdTexture.textureNames {
//            let texture = birdTexture.textureNamed(textureName)
//            birdTextureArray.append(texture)
//        }
//        
//        let flyingAnimation = SKAction.animate(with: birdTextureArray, timePerFrame: 0.1)
                
        // Create
        let bird = SKSpriteNode(imageNamed: "bird1")
        bird.position = CGPoint(x: self.size.width / 2, y: 350)
        bird.zPosition = 2
//        bird.run(SKAction.repeatForever(flyingAnimation))
        
        self.addChild(bird)
    }
    
    func createEnvironment() {
        let land = SKSpriteNode(imageNamed: "land")
        land.position = CGPoint(x: self.size.width / 2, y: 50)
        land.zPosition = 3
        self.addChild(land)
        
        let sky = SKSpriteNode(imageNamed: "sky")
        sky.position = CGPoint(x: self.size.width / 2, y: 100)
        sky.zPosition = 1
        self.addChild(sky)
        
        
        let ceiling = SKSpriteNode(imageNamed: "ceiling")
        ceiling.position = CGPoint(x: self.size.width / 2, y: self.size.height)
        ceiling.zPosition = 3
        self.addChild(ceiling)
        
        let bottomPipe = SKSpriteNode(imageNamed: "pipe")
        bottomPipe.position = CGPoint(x: self.size.width / 2, y: 0)
        bottomPipe.zPosition = 2
        self.addChild(bottomPipe)
        
        let topPipe = SKSpriteNode(imageNamed: "pipe")
        topPipe.position = CGPoint(x: self.size.width / 2, y: self.size.height)
        topPipe.zPosition = 2
        topPipe.xScale = -1
        topPipe.zRotation = .pi
        
        self.addChild(topPipe)
    }
}
