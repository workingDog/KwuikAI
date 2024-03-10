//
//  KeyView.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/04/09.
//

import Foundation
import SwiftUI
import OpenAISwift


struct KeyView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(OpenAiModel.self) var openAI: OpenAiModel
    @Environment(InterfaceModel.self) var interface
    
    @State var theKey = ""
    
    var body: some View {
        @Bindable var interface = interface
        ZStack {
            interface.backColor
            VStack (alignment: .leading, spacing: 60) {
#if targetEnvironment(macCatalyst)
                HStack {
                    Button("Done") {
                        dismiss()
                    }.padding(10)
                    Spacer()
                }
#endif
                
                HStack {
                    Spacer()
                    VStack (spacing: 20) {
                        Text("Copy your OpenAI key from")
                        Text("[OpenAI account](https://platform.openai.com/account/api-keys)")
                    }
                    Spacer()
                }.padding(.top, 50)
                
                CustomSecureField(backColor: $interface.backColor, password: $theKey)
                    .foregroundColor(.blue)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding(.top, 50)
                    .padding(.horizontal, 8)
                
                HStack {
                    Spacer()
                    Button(action: doSaveKey ) {
                        Text("Save").padding(10)
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                
                Spacer()
            }
            .onAppear {
                theKey = StoreService.getKey() ?? ""
            }
        }
        .preferredColorScheme(interface.isDarkMode ? .dark : .light)
    }
    
    func doSaveKey() {
        if StoreService.getKey() == nil {
            StoreService.setKey(key: theKey)
        } else {
            StoreService.updateKey(key: theKey)
        }
        openAI.updateClientKey(theKey)
        dismiss()
    }
}

