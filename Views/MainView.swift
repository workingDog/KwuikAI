//
//  MainView.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/04/11.
//

import Foundation
import SwiftUI
import OpenAISwift


struct MainView: View {
    @Environment(OpenAiModel.self) var openAI: OpenAiModel
    @Environment(InterfaceModel.self) var interface
    
    @State private var text = ""
    @State private var isThinking = false
    @State private var isPressed = false
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    
    var focusValue: FocusState<Bool>.Binding
    
    
    var body: some View {
        @Bindable var openAI = openAI
        VStack(spacing: 1) {
            inputView
            CompletionView(isThinking: $isThinking, isFocused: focusValue)
            Spacer()
        }
        .alert("No results available", isPresented: $openAI.errorDetected) {
            Button("OK") { }
        } message: { Text("Check your OpenAI api key \n or account limit") }
    }
    
    var inputView: some View {
        VStack (spacing: 4) {
            Button(action: {
                isPressed.toggle()
                focusValue.wrappedValue = false
                doAsk()
            }) {
                Text(openAI.selectedMode == .chat ? "Chat" : openAI.selectedMode == .image ? "Image" : "Camera")
                .font(Font.custom("Didot-Italic", size: 18))
                .frame(width: 80, height: 80)
                .foregroundColor(interface.textColor)
                .background(isPressed ? interface.copyColor : interface.questionColor)
                .animation(.easeInOut(duration: 0.2)
                    .reverse(on: $isPressed, delay: 0.2), value: isPressed)
                .clipShape(Circle())
            }.shadow(radius: 10)

            ChatBubble(direction: .left) {
                TextEditor(text: $text)
                    .focused(focusValue)
                    .frame(height: 110)
                    .font(.callout)
                    .padding(.all, 10)
                    .scrollContentBackground(.hidden)
                    .foregroundColor(interface.textColor)
                    .background(interface.questionColor)
            }
        }
    }
    
    func doAsk() {
        Task { @MainActor in   // <--- do task on the main thread
            if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                isThinking = true
                await openAI.getResponse(from: text)
                isThinking = false
                text = ""
            }
        }
    }
    
}
