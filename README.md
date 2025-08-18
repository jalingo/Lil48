# Lil48 Game Library

Character-based puzzle game with SwiftUI and TDD architecture.

## Features

- **Movement System**: Directional swipe gestures with collision detection
- **Character Promotion**: 2048-style merging of identical characters
- **Dynamic Grid System**: Expandable grid from 2x2 up to 5x5 with character preservation
- **Grid Operations**: Place, remove, and slide characters with intelligent collision detection
- **SwiftUI Interface**: Interactive game view with tap and swipe controls

## Character Progression

Cool Kitty Kate → Bully Bob → Quick Rick → Sniffling Steve → Principal Yavno → Super Cool Kitty Kate

## Development Commands

```bash
# Run tests
swift test

# Build library
swift build

# Run console demo
swift run Lil48App
```

## Changes

17 Aug 2025: Dynamic Grid Expansion and Code Refactoring
- Implement dynamic grid expansion system (2x2 to 5x5)
- Add Super Cool Kitty Kate collision triggers automatic grid expansion
- Refactor character promotion logic into separate testable methods
- Enhance TDD workflow with user test verification process

17 Aug 2025: Interface Cleanup and Character Promotion
- Remove demo button and runDemo method
- Implement character promotion system using TDD
- Add collision detection to movement system