//
//  ProfanityFilter.swift
//  GoshDarnIt
//
//  Created by Ryan Maxwell on 27/09/16.
//  Copyright © 2016 Cactuslab. All rights reserved.
//

import Foundation

class ProfanityResources {
    
    class func profanityFileURL() -> URL? {
        return Bundle(for: ProfanityResources.self).url(forResource: "Profanity", withExtension: "json")
    }
}

struct ProfanityDictionary {
    
    static let profaneWords: Set<String> = {
        
        guard let fileURL = ProfanityResources.profanityFileURL() else {
            return Set<String>()
        }
        
        do {
            let fileData = try Data(contentsOf: fileURL, options: NSData.ReadingOptions.uncached)
            
            guard let words = try JSONSerialization.jsonObject(with: fileData, options: []) as? [String] else {
                return Set<String>()
            }
            
            return Set(words)
            
        } catch {
            return Set<String>()
        }
    }()
}

public struct ProfanityFilter {
    
    static func censorString(_ string: String, filter: [FilterType]) -> String {
        var cleanString = string
        
        if filter.contains(.profanity) {
            for word in string.profaneWords() {
                let cleanWord = word.replaceWithAsterisks()
                cleanString = cleanString.replacingOccurrences(of: word, with: cleanWord, options: [.   caseInsensitive], range: nil)
            }
        }
        
        if filter.contains(.emails) || filter.contains(.websites) {
            cleanString = self.blockOther(cleanString, filter: filter)
        }
        
        return cleanString
    }
    
    static func blockOther(_ string: String, filter: [FilterType]) -> String {
        var cleanString = string
        
        for words in string.components(separatedBy: " ") {
            if words.isValidEmail() && filter.contains(.emails){
                cleanString = cleanString.replacingOccurrences(of: words, with: words.replaceWithAsterisks())
            } else if words.isValidWebsite() && filter.contains(.websites) {
                cleanString = cleanString.replacingOccurrences(of: words, with: words.replaceWithAsterisks())
            }
            
        }
        return cleanString
    }
}

public extension String {
    
    public func isValidWebsite() -> Bool {
        let websiteRegEx = "[A-Z0-0a-z]+\\.[A-Za-z]{2,}"
        
        let websiteRegEx2 = "[A-Za-z]+\\.[A-Z0-0a-z]+\\.[A-Za-z]{2,}"
        let webTest2 = NSPredicate(format: "SELF MATCHES %@", websiteRegEx2)
        let webTest = NSPredicate(format: "SELF MATCHES %@", websiteRegEx)
        
        if webTest.evaluate(with: self) ||  webTest2.evaluate(with: self)  {
            return true
        } else {
            return false
        }
    }
    
    public func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+[@][A-Za-z0-9.-]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    public func profaneWords() -> Set<String> {
        
        var delimiterSet = CharacterSet()
        delimiterSet.formUnion(CharacterSet.punctuationCharacters)
        delimiterSet.formUnion(CharacterSet.whitespacesAndNewlines)
        
        let words = Set(self.lowercased().components(separatedBy: delimiterSet))
        
        let x = words.intersection(ProfanityDictionary.profaneWords)
        
        return x
    }
    
    public func containsProfanity() -> Bool {
        return !profaneWords().isEmpty
    }
    
    public func censored(_ filter: [FilterType]) -> String {
        return ProfanityFilter.censorString(self, filter: filter)
    }
    
    public mutating func censor(_ filter: [FilterType] = [.profanity]) {
        self = censored(filter)
    }
    func replaceWithAsterisks() -> String {
        return "".padding(toLength: self.characters.count, withPad: "*", startingAt: 0)
    }
}

public extension NSString {
    
    public func censored(_ filter: [FilterType] = [.profanity]) -> NSString {
        return ProfanityFilter.censorString(self as String, filter: filter) as NSString
    }
}

public extension NSMutableString {
    
    public func censor(_ filter: [FilterType] = [.profanity]) {
        setString(ProfanityFilter.censorString(self as String, filter: filter))
    }
}

public enum FilterType { case profanity, websites, emails }


public extension NSAttributedString {
    
    public func censored(_ filter: [FilterType] = [.profanity]) -> NSAttributedString {
        
        let profaneWords = string.profaneWords()
        var cleanString = NSMutableAttributedString(attributedString: self)
        
        if filter.contains(.emails) || filter.contains(.websites) {
            let filteredWord = cleanString.string.censored(filter)
            cleanString = NSMutableAttributedString(string: filteredWord)
        }
        
        if profaneWords.isEmpty {
            return cleanString
        }
        
        if filter.contains(.profanity) {
            for word in profaneWords {
                
                let cleanWord = word.replaceWithAsterisks()
                
                var range = (cleanString.string as NSString).range(of: word, options: .caseInsensitive)
                while range.location != NSNotFound {
                    let attributes = cleanString.attributes(at: range.location, effectiveRange: nil)
                    let cleanAttributedString = NSAttributedString(string: cleanWord, attributes: attributes)
                    cleanString.replaceCharacters(in: range, with: cleanAttributedString)
                    
                    range = (cleanString.string as NSString).range(of: word, options: .caseInsensitive)
                }
            }
        }
        return cleanString
    }
}
