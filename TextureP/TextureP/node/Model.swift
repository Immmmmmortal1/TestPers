//
//  Model.swift
//  TextureP
//
//  Created by ykmason on 2025/5/22.
//

import Foundation
enum MessageType {
    case incoming
    case outgoing
}

struct Message {
    let text: String
    let type: MessageType
    let isReply: Bool
    let imageName: String
    let imageNames: [String]
    let isSelected: Bool = false
    var isHasImage: Bool {
        !imageName.isEmpty
    }
}
