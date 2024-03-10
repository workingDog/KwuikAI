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
    @State private var interface = InterfaceModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(openAI)
                .environment(interface)
                .environment(\.locale, Locale(identifier: interface.kwuiklang))
                .preferredColorScheme(interface.isDarkMode ? .dark : .light)
        }
    }
}
