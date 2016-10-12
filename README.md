# GoshDarnIt
Profanity filter written in Swift, with censoring extensions for String, NSString, NSMutableString and NSAttributedString

##Usage

- Return a clean version of a string by calling `censored()`

```swift
let insult = "Hey dick-nose"
let clean = insult.censored() // Hey ****-nose
```

- Censor a mutable string in place by calling `censor()`

```swift
var insult = "Eat a bag of dicks."
insult.censor() 
print(insult) // Eat a bag of *****.
```