# Grapher

iOS playground of GitHub API v4 with Kotlin

## Requirements

- Swift 4.2+
- iOS 11.0+
- Xcode 10+
- Carthage 0.29.0+

## Get Started

```bash
# Download
$ git clone git@github.com:muniere/grapher-ios.git

# Init
$ carthage bootstrap --platform iOS

# Configuration
$ cp Grapher/Classes/Environment.swift.example Grapher/Classes/Environment.swift
$ vim Grapher/Classes/Environment.swift

# Open this project with Android Studio, and Select "Run > Run 'app'"
$ open ./Grapher.xcodeproj
```

## Generate

```bash
# Prepare
$ npm install -g apollo

# Generate
$ apollo codegen:generate --schema Grapher/Resources/schema.json --queries Grapher/**/*.graphql --target swift Grapher/Classes/Network/
```
