//
//  ColorView.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/03/29.
//

import Foundation
import SwiftUI



struct ColorView: View {
    @Environment(OpenAiModel.self) var openAI: OpenAiModel

    var body: some View {
        @Bindable var openAI = openAI
        VStack {
            HStack {
                ColorPicker("Colors", selection: Binding<Color>(
                    get: {
                        switch openAI.selectedColor {
                            case .back: return openAI.backColor
                            case .text: return openAI.textColor
                            case .question: return openAI.questionColor
                            case .answer: return openAI.answerColor
                            case .copy: return openAI.copyColor
                            case .tools: return openAI.toolsColor
                        }
                    },
                    set: {
                        switch openAI.selectedColor {
                            case .back: openAI.backColor = $0
                            case .text: openAI.textColor = $0
                            case .question: openAI.questionColor = $0
                            case .answer: openAI.answerColor = $0
                            case .copy: openAI.copyColor = $0
                            case .tools: openAI.toolsColor = $0
                        }
                    }
                ))
                .frame(width: 111, height: 60)
                .padding(15)
                Spacer()
                Toggle(isOn: $openAI.isDarkMode) {
                    Text("Dark")
                }.frame(width: 110)
                 .padding(15)
            }
            Picker("", selection: $openAI.selectedColor) {
                Text("Back").tag(OpenAiModel.ColorType.back)
                Text("Text").tag(OpenAiModel.ColorType.text)
                Text("Question").tag(OpenAiModel.ColorType.question)
            }
            .pickerStyle(.segmented)
            Picker("", selection: $openAI.selectedColor) {
                Text("Answer").tag(OpenAiModel.ColorType.answer)
                Text("Copy").tag(OpenAiModel.ColorType.copy)
                Text("Tools").tag(OpenAiModel.ColorType.tools)
            }
            .pickerStyle(.segmented)
        }
    }
}

