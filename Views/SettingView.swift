//
//  SettingView.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/03/26.
//

import Foundation
import SwiftUI
import OpenAISwift

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(OpenAiModel.self) var openAI: OpenAiModel
    
    @State var showKey = false
    
    var body: some View {
        ZStack {
            openAI.backColor
            ScrollView {
                VStack (alignment: .leading, spacing: 15) {
                #if targetEnvironment(macCatalyst)
                    HStack {
                        Button("Done") {
                            dismiss()
                        }.padding(10)
                        Spacer()
                    }
                #endif
                    Spacer()

                    ParameterView()
                    
                    Divider()
                    ColorView()
                    
                    Spacer()

                    Divider()
                    HStack {
                        Spacer()
                        Button(action: {showKey = true}) {
                            Text("Enter key").padding(15)
                        }
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 12).fill(.pink))
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 8)
            }
        }
        .sheet(isPresented: $showKey) {
            KeyView().environment(openAI)
        }
        .preferredColorScheme(openAI.isDarkMode ? .dark : .light)
        .environment(\.locale, Locale(identifier: openAI.kwuiklang))
        .onDisappear {
            doSave()
        }
    }
    
    func doSave() {
        StoreService.setColor(OpenAiModel.ColorType.back, color: openAI.backColor)
        StoreService.setColor(OpenAiModel.ColorType.text, color: openAI.textColor)
        StoreService.setColor(OpenAiModel.ColorType.question, color: openAI.questionColor)
        StoreService.setColor(OpenAiModel.ColorType.answer, color: openAI.answerColor)
        StoreService.setColor(OpenAiModel.ColorType.copy, color: openAI.copyColor)
        StoreService.setColor(OpenAiModel.ColorType.tools, color: openAI.toolsColor)
        StoreService.setLang(openAI.kwuiklang)
        StoreService.setDisplayMode(openAI.isDarkMode)
        
        dismiss()
    }
    
}

