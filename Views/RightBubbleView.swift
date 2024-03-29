//
//  RightBubbleView.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/03/30.
//

import Foundation
import SwiftUI
import OpenAISwift


struct RightBubbleView: View {
    @Environment(OpenAiModel.self) var openAI: OpenAiModel
    @Environment(InterfaceModel.self) var interface
    
    @State var converse: Conversation
    @Binding var isThinking: Bool
    
    @State var isPressed = false
    @State var tappedImageId: UUID?
    
    let pace = 0.05
    @State private var letters: [String] = []
    @State private var displayText = ""
    @State private var animating = false
 
    var body: some View {
        
        ChatBubble(direction: .right) {
            if isThinking && (converse.id == openAI.conversations.last?.id) {
                ProgressView()
                 //   .progressViewStyle(IconRotateStyle())
                    .frame(width: 333, height: 111)
                    .padding(.all, 10)
                    .background(interface.answerColor)
            } else {
                if let answers = converse.answers {
                    ForEach(answers) { answer in
                       // Text(displayText)
                        Text(answer.text)
                            .padding(.all, 15)
                            .foregroundColor(interface.textColor)
                            .background(isPressed ? interface.copyColor : interface.answerColor)
                            .onTapGesture {
                                UIPasteboard.general.string = answer.text
                                isPressed.toggle()
                            }
                            .animation(.easeInOut(duration: 0.2)
                                .reverse(on: $isPressed, delay: 0.2), value: isPressed)
//                            .onAppear {
//                                animateText(answer.text)
//                            }
                    }
                }
                if let imgages = converse.images {
                    ScrollView (.horizontal){
                        HStack {
                            ForEach(imgages) { img in
                                Image(uiImage: img.uimage)
                                    .resizable()
                                    .frame(width: 333, height: 333)
                                    .onTapGesture {
                                        UIPasteboard.general.image = img.uimage
                                        tappedImageId = img.id
                                        isPressed.toggle()
                                    }
                                    .border(isPressed && (tappedImageId == img.id) ? interface.copyColor : .clear, width: 4)
                                    .animation(.easeInOut(duration: 0.2)
                                        .reverse(on: $isPressed, delay: 0.2), value: isPressed)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func animateText(_ txt: String) {
        animating = true
        displayText = ""
        letters = Array(txt).map { String($0) }
        loop()
    }

    private func loop() {
        if !letters.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + pace) {
                displayText += letters.removeFirst()
                loop()
            }
        } else {
            animating = false
        }
    }
    
}
