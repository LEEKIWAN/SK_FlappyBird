//
//  PhysicsCategory.swift
//  FlappyBird
//
//  Created by 이기완 on 2019/10/18.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

struct PhysicsCateogry {
    static let bird: UInt32 = 0x1 << 0
    static let land: UInt32 = 0x1 << 1
    static let ceiling: UInt32 = 0x1 << 2
    static let pipe: UInt32 = 0x1 << 3
    static let score: UInt32 = 0x1 << 4
}
