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
            case .chat: await getChats(from: text)
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

            if let output = results.choices {
                // Note: chats are kept in chats, but displayed from answers
                output.forEach { msg in
                    conversations.last?.chats?.append(msg.message)
                    if let cleaned = msg.message.content?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        conversations.last?.answers?.append(TextAnswer(text: cleaned))
                    }
                }
            } else {
                errorDetected = true
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

            if let output = results.data {
                // fetch all images in parallel
                await withTaskGroup(of: UIImage?.self) { group in
                    for item in output {
                        if let url = URL(string: item.url) {
                            group.addTask { await self.fetchImage(url: url) }
                        }
                    }
                    for await img in group {
                        if let image = img, conversations.last?.images != nil {
                            conversations.last?.images!.append(ImageAnswer(uimage: image))
                        }
                    }
                }
            } else {
                errorDetected = true
            }
        } catch {
            print(error)
        }
    }
     
}
