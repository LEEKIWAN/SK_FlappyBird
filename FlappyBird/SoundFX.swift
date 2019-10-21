//
//  SoundFX.swift
//  FlappyBird
//
//  Created by kiwan on 2019/10/21.
//  Copyright © 2019 kiwan. All rights reserved.
//

import SpriteKit

struct SoundFX {
    static let wing = SKAction.playSoundFileNamed("sfxWing.mp3", waitForCompletion: false)
    static let die = SKAction.playSoundFileNamed("sfxDie.mp3", waitForCompletion: false)
    static let hit = SKAction.playSoundFileNamed("sfxHit.mp3", waitForCompletion: false)
    static let point = SKAction.playSoundFileNamed("sfxPoint.mp3", waitForCompletion: false)
    static let swooshing = SKAction.playSoundFileNamed("sfxSwooshing.mp3", waitForCompletion: false)
}

