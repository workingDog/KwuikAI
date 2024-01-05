//
//  CompletionView.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/03/28.
//

import Foundation
import SwiftUI
import OpenAISwift



struct CompletionView: View {
    @Environment(OpenAiModel.self) var openAI: OpenAiModel

    @Binding var isThinking: Bool
    var isFocused: FocusState<Bool>.Binding
    
    @State var isPressed = false
    
    var body: some View {
        if !openAI.conversations.isEmpty {
            ScrollViewReader { proxy in
                List {
                    ForEach(openAI.conversations) { converse in
                        ZStack {
                            Color.white.opacity(0.001).ignoresSafeArea(.all)
                                .onTapGesture { isFocused.wrappedValue = false }
                            VStack {
                                ChatBubble(direction: .left) {
                                    Text(converse.question)
                                        .padding(.all, 15)
                                        .foregroundColor(openAI.textColor)
                                        .background(isPressed && (openAI.selectedConversation?.id == converse.id) ? openAI.copyColor : openAI.questionColor)
                                }
                                .onTapGesture {
                                    UIPasteboard.general.string = converse.question
                                    openAI.selectedConversation = converse
                                    isPressed.toggle()
                                }
                                .animation(.easeInOut(duration: 0.2)
                                    .reverse(on: $isPressed, delay: 0.2), value: isPressed)
                                
                                RightBubbleView(converse: converse, isThinking: $isThinking)
                            }
                        }
                        .id(converse.id.uuidString)
                        .listRowBackground(openAI.backColor)
                        .simultaneousGesture(TapGesture()
                            .onEnded {
                                openAI.selectedConversation = converse
                                isFocused.wrappedValue = false
                            })
                    }
                    .onDelete { index in
                        if let firstNdx = index.first {
                            openAI.conversations.remove(at: firstNdx)
                        }
                    }
                    Spacer().frame(width: 1, height: 1).id("end of list")
                }
                .listStyle(.inset)
                .scrollContentBackground(.hidden)
                //                .onChange(of: openAI.haveResponse) { _ in
                //                    if let last = openAI.conversations.last {
                //                        proxy.scrollTo(last.id)
                //                        print("----> go to end of list \(last.id)")
                //                    }
                //                }
                .onChange(of: openAI.haveResponse) { 
                    proxy.scrollTo("end of list")
                }
            }
        }
    }
    
}

