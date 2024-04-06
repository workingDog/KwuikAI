//
//  ContentView.swift
//  KwuikAI
//  new
//  Created by Ringo Wathelet on 2023/03/26.
//
import Foundation
import SwiftUI
import OpenAISwift
import Observation


struct ContentView: View {
    @Environment(OpenAiModel.self) var openAI
    @Environment(InterfaceModel.self) var interface
    
    @State var showSettings = false
    @State var showShareSheet = false
    
    @FocusState var focusValue: Bool
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [interface.backColor, .white]),
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea(.all)
            .onTapGesture { focusValue = false }
            VStack(spacing: 3) {
                theToolbar.padding(5)
                MainView(focusValue: $focusValue).offset(x: 0, y: -16)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingView()
                .environment(openAI)
                .environment(interface)
        }
        .sheet(isPresented: $showShareSheet) {
            if let txt = openAI.selectedConversation?.answers?.compactMap({$0.text}).first {
                ShareSheet(activityItems: [txt])
            } else {
                if let imgages = openAI.selectedConversation?.images?.compactMap({$0.uimage}) {
                    ShareSheet(activityItems: imgages)
                } else {
                    ShareSheet(activityItems: ["nothing to share"])
                }
            }
        }
    }
    
    @ViewBuilder
    var theToolbar: some View {
        VStack {
            HStack {
                leftButtons
                Spacer()
                modesButton
                Spacer()
                settingsButton
            }.foregroundColor(interface.toolsColor)
                .font(.title)
                .padding(.bottom, 8)
            
            wavyLine.padding(.vertical, 10)
        }
    }
    
    @ViewBuilder
    var wavyLine: some View {
        Path { path in
            path.move(to: .zero)
            for i in 0...300 {
                let x = CGFloat(i) * 10.0
                let y = sin(Double(i) * 0.2) * 10.0
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }.stroke(interface.toolsColor, lineWidth: 2)
            .frame(maxHeight: 10)
            .offset(x: -10, y: 0)
    }
    
    @ViewBuilder
    var modesButton: some View {
        @Bindable var openAI = openAI
        Picker("", selection: $openAI.selectedMode) {
            Image(systemName: "ellipsis.message").tag(ModeType.chat)
            Image(systemName: "photo").tag(ModeType.image)
        }.pickerStyle(.segmented)
            .foregroundStyle(interface.toolsColor, .blue)
            .frame(width: 130)
            .scaleEffect(1.2)
    }
    
    @ViewBuilder
    var settingsButton: some View {
        Button(action: { showSettings = true }) {
            Image(systemName: "gearshape")
        }
    }
    
    @ViewBuilder
    var leftButtons: some View {
        HStack (spacing: 10){
            Button(action: { openAI.conversations.removeAll() }) {
                Image(systemName: "trash")
            }
            Button(action: { showShareSheet = true }) {
                Image(systemName:"square.and.arrow.up")
            }
        }
    }
    
}
