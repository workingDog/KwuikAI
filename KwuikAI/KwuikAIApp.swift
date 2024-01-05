//
//  KwuikAIApp.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/04/10.
//

import SwiftUI
import Observation

@main
struct KwuikAIApp: App {
    @State private var openAI = OpenAiModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(openAI)
                .environment(\.locale, Locale(identifier: openAI.kwuiklang))
                .preferredColorScheme(openAI.isDarkMode ? .dark : .light)
        }
    }
}
