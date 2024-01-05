//
//  ParameterView.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/03/29.
//

import Foundation
import SwiftUI



struct ParameterView: View {
    @Environment(OpenAiModel.self) var openAI: OpenAiModel
    @State private var lang = "en"
    
    var body: some View {
        @Bindable var openAI = openAI
        VStack {

            HStack {
                HStack {
                    Text("Temperature")
                    Text(" \(openAI.temperature, specifier: "%.1f")     ").foregroundColor(.blue)
                }
                Spacer()
                Slider(value: $openAI.temperature, in: 0...1, step: 0.1)
            }
            
            HStack {
                HStack {
                    Text("Max tokens")
                    Text(" \(Int(openAI.maxTokens))   ").foregroundColor(.blue)
                }
                Spacer()
                Slider(value: $openAI.maxTokens, in: 100...2000, step: 100)
            }
            
            HStack {
                Text("Max images")
                Picker("", selection: $openAI.numImages) {
                    ForEach(1..<6) { n in
                        Text("\(n)").tag(n)
                    }
                }.pickerStyle(.automatic).frame(width: 80)
                Spacer()
            }
            
            HStack {
                Picker("", selection: $openAI.kwuiklang) {
                    Text(verbatim: "English").tag("en")
                    Text(verbatim: "日本語").tag("ja")
                }.pickerStyle(.segmented).frame(width: 222)
            }.padding(10)

        }
    }
}
