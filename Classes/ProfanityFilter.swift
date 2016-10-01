//
//  ProfanityFilter.swift
//  GoshDarnIt
//
//  Created by Ryan Maxwell on 27/09/16.
//  Copyright © 2016 Cactuslab. All rights reserved.
//

import Foundation

class ProfanityResources {
    
    class func profanityFileURL() -> NSURL? {
        return NSBundle(forClass: ProfanityResources.self).URLForResource("Profanity", withExtension: "json")
    }
}

struct ProfanityDictionary {
    
    static let profaneWords: Set<String> = {
        
        guard let fileURL = ProfanityResources.profanityFileURL() else {
            return Set<String>()
        }
        
        do {
            let fileData = try NSData(contentsOfURL: fileURL, options: NSDataReadingOptions.DataReadingUncached)
            
            guard let words = try NSJSONSerialization.JSONObjectWithData(fileData, options: []) as? [String] else {
                return Set<String>()
            }
            
            return Set(words)
            
        } catch {
            return Set<String>()
        }
    }()
}

public struct ProfanityFilter {
    
    static func censorString(string: String) -> String {
        var cleanString = string
        
        for word in string.profaneWords() {
            
            let cleanWord = "".stringByPaddingToLength(word.characters.count, withString: "*", startingAtIndex: 0)
            
            cleanString = cleanString.stringByReplacingOccurrencesOfString(word, withString: cleanWord, options: [.CaseInsensitiveSearch], range: nil)
        }
        
        return cleanString
    }
}

public extension String {
    
    public func profaneWords() -> Set<String> {
        let delimiterSet = NSMutableCharacterSet()
        delimiterSet.formUnionWithCharacterSet(NSCharacterSet.punctuationCharacterSet())
        delimiterSet.formUnionWithCharacterSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let words = Set(self.lowercaseString.componentsSeparatedByCharactersInSet(delimiterSet))
        
        return words.intersect(ProfanityDictionary.profaneWords)
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
        return ProfanityFilter.censorString(self as String)
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
            
            let cleanWord = "".stringByPaddingToLength(word.characters.count, withString: "*", startingAtIndex: 0)
            
            var range = (cleanString.string as NSString).rangeOfString(word, options: .CaseInsensitiveSearch)
            while range.location != NSNotFound {
                let attributes = cleanString.attributesAtIndex(range.location, effectiveRange: nil)
                let cleanAttributedString = NSAttributedString(string: cleanWord, attributes: attributes)
                cleanString.replaceCharactersInRange(range, withAttributedString: cleanAttributedString)
                
                range = (cleanString.string as NSString).rangeOfString(word, options: .CaseInsensitiveSearch)
            }
        }
        
        return cleanString
    }
}
