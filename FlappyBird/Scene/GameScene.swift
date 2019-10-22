//
//  GameScene.swift
//  FlappyBird
//
//  Created by kiwan on 2019/10/18.
//  Copyright © 2019 kiwan. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameState {
    case ready
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var background = SKSpriteNode()
    
    var bgmPlayer = SKAudioNode()
    let cameraNode = SKCameraNode()
    var bird: SKNode = SKSpriteNode(imageNamed: "bird1")
    
    var gameState: GameState = .ready
    
    var tutorial = SKSpriteNode(imageNamed: "tutorial")
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    var scoreLabel = SKLabelNode(fontNamed: "Minercraftory")
    
    //MARK: - Life Cycle
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 81 / 255, green: 192 / 255, blue: 201 / 255, alpha: 1.0)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        createTutorial()
        createSocre()
        createBird()
        createEnvironment()
        createRain()
        
        bgmPlayer = SKAudioNode(fileNamed: "bgm.mp3")
        bgmPlayer.autoplayLooped = true
        self.addChild(bgmPlayer)
        
        self.camera = cameraNode
        cameraNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(cameraNode)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let rotation = self.bird.zRotation
        if rotation > 0 {
            self.bird.zRotation = min(rotation, 0.7)
        }
        else {
            self.bird.zRotation = max(rotation, -0.7)
        }
        
        if self.gameState == .dead {
            self.bird.physicsBody?.velocity.dx = 0
        }
    }
    
     //MARK: - Create
    
    func createTutorial() {
        tutorial.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        tutorial.zPosition = Layer.tutorial
        addChild(tutorial)
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
        // Create
        bird.position = CGPoint(x: self.size.width / 4, y: self.size.height / 2)
        bird.zPosition = Layer.bird
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.frame.size.height / 2)
        bird.physicsBody?.categoryBitMask = PhysicsCateogry.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCateogry.land | PhysicsCateogry.pipe | PhysicsCateogry.ceiling | PhysicsCateogry.score
        bird.physicsBody?.collisionBitMask = PhysicsCateogry.land | PhysicsCateogry.pipe | PhysicsCateogry.ceiling
        bird.physicsBody?.isDynamic = false
        bird.physicsBody?.affectedByGravity = true
                
        self.addChild(bird)
        
        let flyingAction = SKAction(named: "Flying")
        bird.run(flyingAction!)
        
        guard let thruster = SKEmitterNode(fileNamed: "Thruster") else { return }
//        thruster.position = CGPoint.zero
        thruster.position = CGPoint(x: -bird.frame.size.width / 2, y: 0)
        thruster.zPosition = -0.1
                
        let thrusterEffect = SKEffectNode()
        thrusterEffect.addChild(thruster)
        bird.addChild(thrusterEffect)
        
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
        
//        let skyTexture = environmentAtlas.textureNamed("sky")
        guard let skyTexture = background.texture else {
            return
        }
        
        let skyCreateCount = Int(ceil(self.size.width / skyTexture.size().width))
        
        for i in 0 ... skyCreateCount {
            let sky = SKSpriteNode(texture: skyTexture)
            sky.anchorPoint = CGPoint.zero
//            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: landTexture.size().height)
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: 0)
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
    
    func createInfinitePipe(duration: TimeInterval) {
        let createPipe = SKAction.run { [weak self] in
            self?.setupPipe(pipeDistance: 100)
        }
        
        let wait = SKAction.wait(forDuration: duration)
        let actionSequence = SKAction.sequence([createPipe, wait])
        
        self.run(SKAction.repeatForever(actionSequence))
        
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
    
    func createRain() {
        guard let rain = SKEmitterNode(fileNamed: "Rain") else { return }
        rain.position = CGPoint(x: self.size.width, y: self.size.height)
        rain.zPosition = Layer.rain
        rain.advanceSimulationTime(30)
        addChild(rain)
    }
    
    
    //MARK: -  Game Over
    
    func gameOver() {
        self.damageEffect()
        self.cameraShake()
        
        self.bird.removeAllActions()
        self.createGameOverBoard()
        self.gameState = .dead
        self.bgmPlayer.run(SKAction.stop())
    }
    
    func damageEffect() {
        let flashNode = SKSpriteNode(color: UIColor.red, size: self.size)
        flashNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        flashNode.zPosition = Layer.hud
        flashNode.name = "flashNode"
        self.addChild(flashNode)
        
        let sequnce = SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.removeFromParent()])
        flashNode.run(sequnce)
        
        let wait = SKAction.wait(forDuration: 1)
        let soundSequence = SKAction.sequence([SoundFX.hit, wait, SoundFX.die])
        run(soundSequence)
        
    }
    
    func cameraShake() {
        let moveLeft = SKAction.moveTo(x: self.size.width / 2 - 5, duration: 0.1)
        let moveRight = SKAction.moveTo(x: self.size.width / 2 + 5, duration: 0.1)
        let moveReset = SKAction.moveTo(x: self.size.width / 2, duration: 0.1)
        
        let shakeAction = SKAction.sequence([moveLeft, moveRight, moveLeft, moveRight, moveReset])
        shakeAction.timingMode = .easeInEaseOut
        self.camera?.run(shakeAction)
    }
    
    
    func createGameOverBoard() {
        recordBestScore()
        
        let gameOverBoard = SKSpriteNode(imageNamed: "gameoverBoard")
        gameOverBoard.position = CGPoint(x: self.size.width / 2, y: -gameOverBoard.size.height)
        gameOverBoard.zPosition = Layer.hud
        self.addChild(gameOverBoard)
        
        var medal: SKSpriteNode
        
        if self.score >= 10 {
            medal = SKSpriteNode(imageNamed: "medalPlatinum")
        }
        else if self.score >= 5 {
            medal = SKSpriteNode(imageNamed: "medalGold")
        }
        else if self.score >= 3 {
            medal = SKSpriteNode(imageNamed: "medalSilver")
        }
        else {
            medal = SKSpriteNode(imageNamed: "medalBronze")
        }
        
        medal.position = CGPoint(x: -gameOverBoard.size.width * 0.27, y: gameOverBoard.size.width * 0.02)
        medal.zRotation = 0.1
        gameOverBoard.addChild(medal)
        
        let scoreLabel = SKLabelNode(fontNamed: "Minercraftory")
        scoreLabel.fontSize = 13
        scoreLabel.fontColor = .orange
        scoreLabel.text = "\(self.score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: gameOverBoard.size.width * 0.35, y: gameOverBoard.size.height * 0.07)
        scoreLabel.zPosition = 0.1
        gameOverBoard.addChild(scoreLabel)
        
        let bestScore = UserDefaults.standard.integer(forKey: "BestScore")
        let bestScoreLabel = SKLabelNode(fontNamed: "Minercraftory")
        bestScoreLabel.fontSize = 13
        bestScoreLabel.fontColor = .orange
        bestScoreLabel.text = "\(bestScore)"
        bestScoreLabel.horizontalAlignmentMode = .left
        bestScoreLabel.position = CGPoint(x: gameOverBoard.size.width * 0.35, y: -gameOverBoard.size.height * 0.07)
        bestScoreLabel.zPosition = 0.1
        gameOverBoard.addChild(bestScoreLabel)
        
        let restartButton = SKSpriteNode(imageNamed: "playBtn")
        restartButton.name = "restartButton"
        restartButton.position = CGPoint(x: 0, y: -gameOverBoard.size.height * 0.35)
        restartButton.zPosition = 0.1
        gameOverBoard.addChild(restartButton)
        
        gameOverBoard.run(SKAction.sequence([SKAction.moveTo(y: self.size.height / 2, duration: 1), SKAction.run({
            self.speed = 0
        })]))
    }
    
    
    func recordBestScore() {
        let userDefaults = UserDefaults.standard
        var bestScore = userDefaults.integer(forKey: "BestScore")
        
        if self.score > bestScore {
            bestScore = self.score
            userDefaults.set(bestScore, forKey: "BestScore")
        }
        userDefaults.synchronize()
    }
    
    //MARK: - Event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch gameState {
        case .ready:
            gameState = .playing
            score = 0
            self.bird.physicsBody?.isDynamic = true
            self.bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
            self.createInfinitePipe(duration: 4)
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let wait = SKAction.wait(forDuration: 0.5)
            let remove = SKAction.removeFromParent()
            self.tutorial.run(SKAction.sequence([fadeOut, wait, remove]))
            
        case .playing:
            self.run(SoundFX.wing)
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
        case .dead:
            let touch = touches.first
            if let location = touch?.location(in: self) {
                let nodesArray = self.nodes(at: location)
                if nodesArray.first?.name == "restartButton" {
                    self.run(SoundFX.swooshing)
                    let scene = MenuScene(size: self.size)
                    let transmission = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    self.view?.presentScene(scene, transition: transmission)

                }
            }
            
        }
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
            if gameState == .playing {
                gameOver()
            }
        case PhysicsCateogry.pipe:
            print("pipe")
            if gameState == .playing {
                gameOver()
            }
        case PhysicsCateogry.score:
            score = score + 1
            self.run(SoundFX.point)
        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
