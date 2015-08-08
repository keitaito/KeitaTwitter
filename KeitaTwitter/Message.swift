//
//  Message.swift
//  KeitaTwitter
//
//  Created by Keita on 8/6/15.
//  Copyright (c) 2015 Keita Ito. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    enum MessageType {
        case Sending
        case Receiving
    }
    
    let text: String
    let type: MessageType
    
    init(text: String, type: MessageType) {
        self.text = text
        self.type = type
    }
   
}
