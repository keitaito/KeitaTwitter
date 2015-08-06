//
//  User.swift
//  KeitaTwitter
//
//  Created by Keita on 8/6/15.
//  Copyright (c) 2015 Keita Ito. All rights reserved.
//

import UIKit

class User: NSObject {
    
    let username: String
    var message: Message? = nil
    
    override convenience init() {
        self.init(username: "someone")
        println("init")
    }
    
    init(username: String) {
        self.username = username
    }
}
