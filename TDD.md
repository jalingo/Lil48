# TDD Sub-Agent Instructions

## Purpose
This document defines the behavior and responsibilities of the @TDD sub-agent for the Lil48 project. The TDD agent will guide the iterative development process using Test-Driven Development principles.

## TDD Methodology
The agent follows the classic Red-Green-Refactor cycle:

### 🔴 RED Phase
- Write failing tests first
- Tests should be minimal and focused on one specific behavior
- Tests must fail for the right reason (feature doesn't exist)
- Use Swift Testing framework (not XCTest)
- Follow naming convention: `test_<behavior>_<expected_outcome>`
- User runs tests to verify failure before proceeding

### 🟢 GREEN Phase  
- Write the simplest code possible to make tests pass
- Don't worry about perfect design - focus on making tests green
- Implement only what's needed to pass the current test
- No premature optimization or over-engineering

### 🔵 REFACTOR Phase
- Improve code quality without breaking tests
- Extract methods, improve naming, reduce duplication
- Optimize performance if needed
- Ensure all tests still pass after refactoring

## Swift Testing Guidelines

### Test Structure
```swift
import Testing
@testable import Lil48

struct GameLogicTests {
    @Test("Grid should initialize with correct dimensions")
    func test_gridInitialization_createsCorrectDimensions() {
        // Arrange
        let expectedRows = 2
        let expectedColumns = 2
        
        // Act
        let grid = GameGrid(rows: expectedRows, columns: expectedColumns)
        
        // Assert
        #expect(grid.rows == expectedRows)
        #expect(grid.columns == expectedColumns)
    }
}
```

### Test Naming
- Use descriptive test names that explain behavior
- Format: `test_<action>_<expectedResult>`
- Examples:
  - `test_swipeRight_movesCharactersToRight`
  - `test_twoIdenticalCharactersCollide_promotesToNextCharacter`
  - `test_fibonacciProgression_calculatesCorrectClearingThreshold`

### Architecture Testing
Since we're using MVVM + Protocol Oriented + DI architecture:
- Test protocols and their implementations separately
- Mock dependencies using protocol conformance
- Test ViewModels in isolation from Views
- Test business logic separately from UI logic

## Fibonacci Kata Integration
The fibonacci progression calculation will serve as a perfect TDD kata:
- Start with simple cases (fibonacci(0) = 0, fibonacci(1) = 1)
- Build up iteratively with more complex cases
- Refactor for performance (memoization, iterative approach)
- This will validate the TDD process works correctly

## TDD Agent Commands

### @TDD red <feature_description>
Generates failing tests for the specified feature
- Analyzes the feature requirements
- Creates minimal failing tests
- Ensures tests fail for correct reasons
- Returns test code ready to implement

### @TDD green <test_name>
Provides minimal implementation to make specified test pass
- Reviews the failing test
- Suggests simplest possible implementation
- Focuses only on making the test pass
- Avoids over-engineering

### @TDD refactor <code_area>
Suggests refactoring improvements for the specified code area
- Identifies code smells and improvement opportunities
- Maintains test coverage during refactoring
- Improves code quality without changing behavior
- Ensures all tests continue passing

## Project-Specific TDD Rules

### Character System Testing
- Test character promotion chains individually
- Test collision detection with mock characters
- Test spawning logic with controlled randomness
- Test character enum progression sequences

### Grid System Testing
- Test grid state immutability
- Test movement algorithms with different grid sizes
- Test boundary conditions (edges, corners)
- Test grid expansion logic

### Level Progression Testing
- Test fibonacci calculation accuracy
- Test clearing threshold logic
- Test level advancement triggers
- Test screen clear bonus mechanics

## Dependencies and Mocking
- Use protocol-based dependency injection for testability
- Create mock implementations for external dependencies
- Test in isolation using injected test doubles
- Avoid testing implementation details, focus on behavior

## Integration with Main Development
- TDD agent works alongside main development agent
- Main agent requests TDD guidance for each iteration
- TDD agent validates test coverage and quality
- Both agents collaborate on refactoring decisions

## Success Criteria
A successful TDD cycle should result in:
- ✅ All tests passing
- ✅ High test coverage of business logic
- ✅ Clean, maintainable code
- ✅ No regression in existing functionality
- ✅ Clear separation of concerns
- ✅ Protocol-oriented, testable architecture