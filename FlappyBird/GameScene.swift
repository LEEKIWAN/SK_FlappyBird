//
//  GameScene.swift
//  FlappyBird
//
//  Created by kiwan on 2019/10/18.
//  Copyright © 2019 kiwan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird: SKNode = SKSpriteNode()
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    var scoreLabel = SKLabelNode(fontNamed: "Minercraftory")
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 81 / 255, green: 192 / 255, blue: 201 / 255, alpha: 1.0)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        createSocre()
        createBird()
        createEnvironment()
        createInfinitePipe(duration: 3)
        
    }
    
    func createSocre() {
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 60)
        scoreLabel.zPosition = Layer.hud
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.text = "\(score)"
        self.addChild(scoreLabel)
    }
    
    func createBird() {
        bird = SKSpriteNode(imageNamed: "bird1")
        // Create
        
        bird.position = CGPoint(x: self.size.width / 2, y: 350)
        bird.zPosition = Layer.bird
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.frame.size.height / 2)
        bird.physicsBody?.categoryBitMask = PhysicsCateogry.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCateogry.land | PhysicsCateogry.pipe | PhysicsCateogry.ceiling | PhysicsCateogry.score
        bird.physicsBody?.collisionBitMask = PhysicsCateogry.land | PhysicsCateogry.pipe | PhysicsCateogry.ceiling
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.affectedByGravity = true
        
        
        self.addChild(bird)
        
        let flyingAction = SKAction(named: "Flying")
        bird.run(flyingAction!)
        
    }
    
    func createEnvironment() {
        let environmentAtlas = SKTextureAtlas(named: "Environment")
        let landTexture = environmentAtlas.textureNamed("land")
        
        let landCreateCount = Int(ceil(self.size.width / landTexture.size().width))
        
        for i in 0 ... landCreateCount {
            let land = SKSpriteNode(texture: landTexture)
            land.anchorPoint = CGPoint.zero
            land.position = CGPoint(x: CGFloat(i) * land.size.width, y: 0)
            land.zPosition = Layer.land
            
            land.physicsBody = SKPhysicsBody(rectangleOf: land.size, center: CGPoint(x: land.size.width / 2, y: land.size.height / 2))
            land.physicsBody?.categoryBitMask = PhysicsCateogry.land
            land.physicsBody?.isDynamic = false
            land.physicsBody?.affectedByGravity = false
            
            self.addChild(land)
            
            let moveLeft = SKAction.moveBy(x: -landTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: landTexture.size().width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            land.run(SKAction.repeatForever(moveSequence))
            
        }
        
        let skyTexture = environmentAtlas.textureNamed("sky")
        let skyCreateCount = Int(ceil(self.size.width / skyTexture.size().width))
        
        for i in 0 ... skyCreateCount {
            let sky = SKSpriteNode(texture: skyTexture)
            sky.anchorPoint = CGPoint.zero
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: landTexture.size().height)
            sky.zPosition = Layer.sky
            
            self.addChild(sky)
            
            let moveLeft = SKAction.moveBy(x: -skyTexture.size().width, y: 0, duration: 40)
            let moveReset = SKAction.moveBy(x: skyTexture.size().width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            sky.run(SKAction.repeatForever(moveSequence))
            
        }
        
        
        let ceilingTexture = environmentAtlas.textureNamed("ceiling")
        let ceilingCreateCount = Int(ceil(self.size.width / ceilingTexture.size().width))
        
        for i in 0 ... ceilingCreateCount {
            let ceiling = SKSpriteNode(texture: ceilingTexture)
            ceiling.anchorPoint = CGPoint.zero
            ceiling.position = CGPoint(x: CGFloat(i) * ceiling.size.width, y: self.view!.frame.height - ceilingTexture.size().height)
            ceiling.zPosition = Layer.celing
            
            ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size, center: CGPoint(x: ceiling.size.width / 2, y: ceiling.size.height / 2))
            ceiling.physicsBody?.categoryBitMask = PhysicsCateogry.ceiling
            ceiling.physicsBody?.isDynamic = false
            ceiling.physicsBody?.affectedByGravity = false
            
            self.addChild(ceiling)
            
            let moveLeft = SKAction.moveBy(x: -ceilingTexture.size().width, y: 0, duration: 3)
            let moveReset = SKAction.moveBy(x: ceilingTexture.size().width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            ceiling.run(SKAction.repeatForever(moveSequence))
            
        }
        
        
        
        
    }
    
    func setupPipe(pipeDistance: CGFloat) {
        let environmentAtlas = SKTextureAtlas(named: "Environment")
        let pipeTexture = environmentAtlas.textureNamed("pipe")
        
        let bottomPipe = SKSpriteNode(texture: pipeTexture)
        bottomPipe.zPosition = Layer.pipe
        
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOf: bottomPipe.size)
        bottomPipe.physicsBody?.categoryBitMask  = PhysicsCateogry.pipe
        bottomPipe.physicsBody?.isDynamic = false
        
        self.addChild(bottomPipe)
        
        let topPipe = SKSpriteNode(imageNamed: "pipe")
        topPipe.zPosition = Layer.pipe
        topPipe.xScale = -1
        topPipe.zRotation = .pi
        
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipe.size)
        topPipe.physicsBody?.categoryBitMask  = PhysicsCateogry.pipe
        topPipe.physicsBody?.isDynamic = false
        
        self.addChild(topPipe)
        
        let pipeCollision = SKSpriteNode(color: .red, size: CGSize(width: 1, height: self.size.height))
        pipeCollision.zPosition = Layer.pipe
        pipeCollision.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.size.height))
        pipeCollision.physicsBody?.categoryBitMask = PhysicsCateogry.score
        pipeCollision.physicsBody?.isDynamic = false
        pipeCollision.name = "pipeCollision"
        
        self.addChild(pipeCollision)
        
        // position
        
        let max = self.size.height * 0.3
        let xPosition = self.size.width + topPipe.size.width
        let yPosition = CGFloat(arc4random_uniform(UInt32(max))) + environmentAtlas.textureNamed("land").size().height
        let endPosition = self.size.width + (bottomPipe.size.width * 2)
        
        
        bottomPipe.position = CGPoint(x: xPosition, y: yPosition)
        topPipe.position = CGPoint(x: xPosition, y: yPosition + pipeDistance + topPipe.size.height)
        pipeCollision.position = CGPoint(x: xPosition, y: self.size.height / 2)
        
        
        let moveLeft = SKAction.moveBy(x: -endPosition, y: 0, duration: 6)
        let moveSequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
        
        topPipe.run(moveSequence)
        bottomPipe.run(moveSequence)
        pipeCollision.run(moveSequence)
    }
    
    
    func createInfinitePipe(duration: TimeInterval) {
        let createPipe = SKAction.run { [weak self] in
            self?.setupPipe(pipeDistance: 100)
        }
        
        let wait = SKAction.wait(forDuration: duration)
        let actionSequence = SKAction.sequence([createPipe, wait])
        
        self.run(SKAction.repeatForever(actionSequence))
        
    }
    
    
    //MARK: - Event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
    }
    
    
    
    //MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        var collideBody = contact.bodyA
        
        if contact.bodyA.categoryBitMask == PhysicsCateogry.bird {
            collideBody = contact.bodyB
        }
        else {
            collideBody = contact.bodyA
        }
        
        
        switch collideBody.categoryBitMask {
        case PhysicsCateogry.ceiling:
            print("ceiling")
        case PhysicsCateogry.land:
            print("land")
        case PhysicsCateogry.pipe:
            print("pipe")
        case PhysicsCateogry.score:
            score = score + 1
        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
