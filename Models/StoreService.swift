//
//  StoreService.swift
//  KwuikAI
//
//  Created by Ringo Wathelet on 2023/03/26.
//

import Foundation
import SwiftUI


class StoreService {

    static func getKey() -> String? {
        KeychainInterface.getPassword()
    }
    
    static func setKey(key: String) {
        do {
            try KeychainInterface.savePassword(key)
        } catch {
            print("in StoreService setKey(), KeychainInterface.savePassword: \(error)")
        }
    }
    
    static func updateKey(key: String) {
        do {
            try KeychainInterface.updatePassword(with: key)
        } catch {
            print("in StoreService updateKey(), KeychainInterface.updatePassword: \(error)")
        }
    }
    
    static func setColor(_ key: OpenAiModel.ColorType, color: Color) {
        do {
            let colorData = try NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false)
            UserDefaults.standard.set(colorData, forKey: "yoyo.kwuikai.color.\(key.rawValue)")
        } catch {
            print("in StoreService setColor error: \(error)")
        }
    }
    
    static func getColor(_ key: OpenAiModel.ColorType) -> Color {
        do {
            if let colorData = UserDefaults.standard.data(forKey: "yoyo.kwuikai.color.\(key.rawValue)"),
               let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
                return Color(uiColor: uiColor)
            }
        } catch {
            print("in StoreService getColor error: \(error)")
        }
        switch key {
            case OpenAiModel.ColorType.back: return Color.teal
            case OpenAiModel.ColorType.text: return Color.white
            case OpenAiModel.ColorType.question: return Color.green
            case OpenAiModel.ColorType.answer: return Color.blue
            case OpenAiModel.ColorType.copy: return Color.red
            case OpenAiModel.ColorType.tools: return Color.blue
        }
    }
    
    static func getLang() -> String {
        return UserDefaults.standard.string(forKey: "yoyo.kwuikai.defaultlang.key") ?? "en"
    }
    
    static func setLang(_ str: String) {
        UserDefaults.standard.set(str, forKey: "yoyo.kwuikai.defaultlang.key")
    }
    
    static func getDisplayMode() -> Bool {
        return UserDefaults.standard.bool(forKey: "yoyo.kwuikai.displaymode.key") 
    }
    
    static func setDisplayMode(_ isDark: Bool) {
        UserDefaults.standard.set(isDark, forKey: "yoyo.kwuikai.displaymode.key")
    }
    
}
