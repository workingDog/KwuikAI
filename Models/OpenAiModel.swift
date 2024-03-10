//
//  OpenAiModel.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/03/26.
//


import Foundation
import SwiftUI
import OpenAISwift
import Observation


@Observable class OpenAiModel {
    var conversations = [Conversation]()
    var selectedConversation: Conversation? = nil
    
    var errorDetected = false
    var haveResponse = false
    
    // model parameters
    var maxTokens = 1000.0
    var temperature = 0.5
    //    var numChoices = 1
    var numImages = 1
    
    var model: OpenAIEndpointModelType.ChatCompletions = .gpt4

    var selectedMode: ModeType = .chat
    
    //@ObservationIgnored @AppStorage("isDarkMode")
    var isDarkMode = false
    
    @ObservationIgnored var client: OpenAISwift
    
    init() {
        let apikey = StoreService.getKey() ?? ""
        client = OpenAISwift(config: .makeDefaultOpenAI(apiKey: apikey))
    }
    
    func updateClientKey(_ apikey: String) {
        client = OpenAISwift(config: .makeDefaultOpenAI(apiKey: apikey))
    }
    
    func getResponse(from text: String) async {
        let chaty = conversations.last(where: { $0.chats != nil })?.chats
        conversations.append(
            Conversation(question: text, answers: [], images: [], chats: chaty))
        
        errorDetected = false
        
        switch selectedMode {
        case .image: await getImages(from: text)
        case .chat:  await getChats(from: text)
        }
        
        DispatchQueue.main.async {
            self.haveResponse.toggle()
        }
    }
    
    func getChats(from text: String) async {
        var chatArr = [ChatMessage]()
        if let msg = conversations.last(where: { $0.chats != nil })?.chats {
            chatArr = msg
        }
        chatArr.append(ChatMessage(role: .user, content: text))
        
        do {
            let results = try await client.sendChat(
                with: chatArr,
                model: model,
                user: nil,
                temperature: temperature,
                topProbabilityMass: 1,
                choices: 1,
                maxTokens: Int(maxTokens)
            )
            
            if results.choices == nil { errorDetected = true }
            
            if let output = results.choices {
                var converse = Conversation(question: text, answers: [], chats: chatArr)
                // Note: chats are kept in chats, but displayed from answers
                output.forEach { msg in
                    converse.chats?.append(msg.message)
                    if let cleaned = msg.message.content?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        converse.answers?.append(TextAnswer(text: cleaned))
                    }
                }
                updateCoversations(converse)
            }
        } catch {
            print(error)
        }
    }

    private func fetchImage(url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let img = UIImage(data: data) {
                return img
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func getImages(from text: String) async {
        do {
            let results = try await client.sendImages(with: text, numImages: numImages)
            
            if results.data == nil { errorDetected = true }
            
            if let output = results.data {
                var converse = Conversation(question: text, images: [])
                // fetch all images in parallel
                await withTaskGroup(of: UIImage?.self) { group in
                    for item in output {
                        if let url = URL(string: item.url) {
                            group.addTask { await self.fetchImage(url: url) }
                        }
                    }
                    for await img in group {
                        if let image = img, converse.images != nil {
                            converse.images!.append(ImageAnswer(uimage: image))
                        }
                    }
                }
                updateCoversations(converse)
            }
        } catch {
            print(error)
        }
    }
    
    private func updateCoversations(_ converse: Conversation) {
        if !conversations.isEmpty {
            conversations.removeLast()
        }
        conversations.append(converse)
    }
    
}
