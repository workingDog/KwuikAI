//
//  Conversation.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/03/30.
//

import Foundation
import SwiftUI
import OpenAISwift


struct TextAnswer: Identifiable, Hashable {
    let id = UUID()
    var text: String
}

struct ImageAnswer: Identifiable, Hashable {
    let id = UUID()
    var uimage: UIImage
}

struct Conversation: Identifiable {
    let id = UUID()
    var question: String
    var answers: [TextAnswer]?
    var images: [ImageAnswer]?
    var chats: [ChatMessage]?  // Note: chats are kept in chats, but displayed from answers
    
    init(question: String = "",
         answers: [TextAnswer]? = nil,
         images: [ImageAnswer]? = nil,
         chats: [ChatMessage]? = nil) {
        
        self.question = question
        self.answers = answers
        self.images = images
        self.chats = chats
    }
}
