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
    
    static func censorString(_ string: String) -> String {
        var cleanString = string
        
        for word in string.profaneWords() {
            
            let cleanWord = "".padding(toLength: word.characters.count, withPad: "*", startingAt: 0)
            
            cleanString = cleanString.replacingOccurrences(of: word, with: cleanWord, options: [.caseInsensitive], range: nil)
        }
        
        return cleanString
    }
}

public extension String {
    
    public func profaneWords() -> Set<String> {
        
        var delimiterSet = CharacterSet()
        delimiterSet.formUnion(CharacterSet.punctuationCharacters)
        delimiterSet.formUnion(CharacterSet.whitespacesAndNewlines)
        
        let words = Set(self.lowercased().components(separatedBy: delimiterSet))
        
        return words.intersection(ProfanityDictionary.profaneWords)
    }
    
    public func containsProfanity() -> Bool {
        return !profaneWords().isEmpty
    }
    
    public func censored() -> String {
        return ProfanityFilter.censorString(self)
    }
    
    public mutating func censor() {
        self = censored()
    }
}

public extension NSString {
    
    public func censored() -> NSString {
        return ProfanityFilter.censorString(self as String) as NSString
    }
}

public extension NSMutableString {
    
    public func censor() {
        setString(ProfanityFilter.censorString(self as String))
    }
}

public extension NSAttributedString {
    
    public func censored() -> NSAttributedString {
        
        let profaneWords = string.profaneWords()
        
        if profaneWords.isEmpty {
            return self
        }
        
        let cleanString = NSMutableAttributedString(attributedString: self)
        
        for word in profaneWords {
            
            let cleanWord = "".padding(toLength: word.characters.count, withPad: "*", startingAt: 0)
            
            var range = (cleanString.string as NSString).range(of: word, options: .caseInsensitive)
            while range.location != NSNotFound {
                let attributes = cleanString.attributes(at: range.location, effectiveRange: nil)
                let cleanAttributedString = NSAttributedString(string: cleanWord, attributes: attributes)
                cleanString.replaceCharacters(in: range, with: cleanAttributedString)
                
                range = (cleanString.string as NSString).range(of: word, options: .caseInsensitive)
            }
        }
        
        return cleanString
    }
}
