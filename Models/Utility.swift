//
//  Utility.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/03/26.
//

import Foundation
import SwiftUI
    
enum ColorType: String, CaseIterable {
    case back, text, question, answer, copy, tools
}
  
enum ModeType: String, CaseIterable {
    case image, chat
}

extension Animation {
    func reverse(on: Binding<Bool>, delay: Double) -> Self {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            on.wrappedValue = false /// Switch off after `delay` time
        }
        return self
    }
}

public struct CustomTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.callout)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.blue, lineWidth: 2))
    }
}

//struct IconRotateStyle: ProgressViewStyle {
//    typealias Body = <#type#>
//    
//    @State var isAnimating = false
//    
//    func makeBody(configuration: Configuration) -> some View {
//        ZStack {
//            Image("kwuikaiicon").resizable().frame(width: 33, height: 33)
//                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0.0))
//                .animation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false), value: isAnimating)
//                .onAppear {
//                    isAnimating = true
//                }
//        }
//    }
//    
//}
