# Lil48 Game Design Document

## Overview
Lil48 is a character-based puzzle game featuring dynamic grid expansion and level progression. Players manipulate LillyPal character tiles on a grid through directional swipes, combining identical characters to progress through a promotion sequence.

## Core Mechanics

### Grid System
- **Starting Grid**: 2x2 tile grid
- **Dynamic Expansion**: Grid grows by 1 row and 1 column each level
- **Maximum Grid**: Scales with player progression (theoretically unlimited)

### Character System
- **Character Sequence**: 6 distinct LillyPal characters with promotion chain:
  - Cool Kitty Kate → Bully Bob → Quick Rick → Sniffling Steve → Principal Yavno → Super Cool Kitty Kate
- **Visual Representation**: Each character has a unique graphic asset from the LillyPalooza collection
- **Character States**: Each grid position can be empty or contain one character

### Movement Mechanics
- **Directional Swipes**: Four directions (up, down, left, right)
- **Tile Sliding**: All tiles slide simultaneously in the chosen direction until blocked
- **Collision Resolution**: When two identical characters collide, they are processed according to promotion rules

### Promotion & Clearing System
- **Character Promotion**: When two identical non-final characters collide:
  - Both characters are removed
  - One character of the next type in sequence appears in their combined position
- **Character Clearing**: When two Super Cool Kitty Kate characters (final in sequence) collide:
  - Both characters disappear completely
  - No replacement character is spawned
  - Clearing counter increments by 1

### Spawning System
- **New Character Generation**: After each valid move, a new Cool Kitty Kate character spawns
- **Spawn Location**: Random empty grid position
- **Spawn Timing**: Only occurs after player input that results in grid changes

### Level Progression
- **Level Advancement**: Player advances when clearing threshold is met
- **Clearing Threshold**: N clearings required where N = fibonacci(level + 2)
  - Level 1: Requires 2 clearings
  - Level 2: Requires 3 clearings
  - Level 3: Requires 5 clearings
  - Level 4: Requires 8 clearings
  - Level 5: Requires 13 clearings (etc.)
- **Grid Expansion**: Each new level increases grid dimensions by 1x1
- **Visual Feedback**: Background color changes with each level
- **Complete Screen Clear Bonus**: If player clears all characters from grid:
  - Grid shrinks by 1x1 (minimum 2x2)
  - Player advances by 1 level
  - Creates strategic risk/reward for aggressive clearing

### Game States
- **Active Play**: Player can make moves, characters can spawn and interact
- **Game Over**: Grid is full and no valid moves remain
- **Level Transition**: Brief state between clearing threshold and grid expansion

### Win/Loss Conditions
- **Primary Goal**: Achieve the highest level possible
- **Game Over**: Occurs when grid fills completely with no possible moves
- **Endless Play**: No traditional "win" condition - focus on high score/level achievement

### Scoring System
- **Level Achievement**: Primary scoring metric
- **Clear Count**: Secondary metric for achievements
- **Move Efficiency**: Potential metric for advanced scoring

## Technical Requirements

### Data Persistence
- High scores and current game state
- Level achievements and statistics
- Game Center leaderboard integration

### User Interface
- Touch-based directional swiping
- Visual character representations
- Level and score displays
- Smooth animations for tile movement and character transitions

### Performance Considerations
- Efficient grid state management
- Smooth animations even with larger grids
- Memory management for character assets
- Responsive touch input handling

## Gameplay Flow

1. **Game Start**: 2x2 grid with one Cool Kitty Kate character
2. **Player Move**: Swipe gesture moves all characters
3. **Collision Resolution**: Handle character promotions/clearings
4. **Character Spawn**: Add new Cool Kitty Kate character to random empty space
5. **Level Check**: Evaluate if clearing threshold met
6. **Screen Clear Check**: If grid completely empty, apply shrink bonus
7. **Grid Expansion**: If level up, expand grid and continue
8. **Game Over Check**: Verify valid moves remain
9. **Repeat**: Return to step 2 or end game

## Core Gameplay Loop

**Primary Player Actions (5-15 seconds):**
1. Assess current grid state and character positions
2. Plan optimal directional swipe strategy
3. Execute swipe gesture
4. Observe collision results and promotions
5. Watch new Cool Kitty Kate character spawn

## Unique Features
- Dynamic grid size creates evolving gameplay complexity
- LillyPal character progression system with beloved characters
- Fibonacci-based clearing thresholds create mathematical strategy
- Screen clearing bonus adds risk/reward depth
- Visual character system enhances player connection
- Endless scalability through unlimited level progression