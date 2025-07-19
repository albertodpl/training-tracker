# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI iOS training tracker app that guides users through workout routines. The app manages timed exercises, repetition-based exercises, and rest periods with sound feedback and visual progression tracking.

## Build and Development Commands

### Building and Testing
- **Build**: Use Xcode to build the project (`Training Tracker.xcodeproj`)
- **Run Tests**: `⌘+U` in Xcode or select the test target "Training Tracker Tests"
- **Run Single Test**: Select specific test method and use `⌘+U`
- **Run App**: `⌘+R` in Xcode or select "Training Tracker" scheme

### Xcode Configuration
- **Scheme**: "Training Tracker" (main app)
- **Test Target**: "Training Tracker Tests"
- **iOS Deployment Target**: 17.2
- **Swift Version**: 5.0

## Architecture and Code Structure

### Core Architecture Pattern
The app follows an **MVC-like pattern with Observable models**:
- **Models**: `@Observable` classes that hold state and business logic
- **Controllers**: Coordinate between models and handle business operations  
- **Views**: SwiftUI views that observe models and trigger controller actions

### Key Components

#### 1. App Lifecycle Management
- `AppLifecycleModel`: Tracks training state (not started, started, completed)
- `AppLifecycleController`: Manages state transitions
- `TrainingLifecycleView`: Root view that switches between lifecycle states

#### 2. Routine Management
- `RoutineModel`: Observable model holding current workout state
- `RoutineController`: Orchestrates workout progression and step transitions
- `RoutineSteps`: Processes JSON workout definitions into executable steps

#### 3. Step Types and Execution
- `Step`: Core data structure representing a workout step
- `StepType`: Enum with two variants:
  - `.timed(TimedStepModel)`: Exercises or rest periods with duration
  - `.reps(RepsStepDefinition)`: Exercises with repetition counts
- `TimerController`: Manages timed step execution with pause/resume

#### 4. JSON Workout Schema
- Workouts defined in JSON files in `Resources/` directory
- `JsonSchemas.swift`: Codable structs for parsing workout JSON
- Supports nested exercise groups, sets, rest periods, and mixed timed/rep exercises

#### 5. Sound System
- `SoundPlayer`: Provides audio feedback for exercise start/end
- Type-aliased as `SoundPlyr` in controller interfaces

#### 6. Testing Framework
- Uses SwiftMock framework (`Mock.swift`) for protocol mocking
- Test files organized in `Training Tracker Tests/` with parallel structure
- Controllers and models have corresponding test files

### Key Abstractions

#### Protocols for Testability
- `RoutineCtrl`: Protocol for routine control operations
- `TimerCtrl`: Protocol for timer control operations  
- `SoundPlyr`: Protocol for sound playback operations
- `PeriodicTimer`: Protocol for timer implementation

#### Dependency Injection
Controllers accept protocol dependencies and builder functions:
```swift
init(routineModel: RoutineModel, 
     appLifecycleController: AppLifecycleController, 
     periodicTimerBuilder: @escaping () -> PeriodicTimer, 
     soundPlayer: SoundPlyr)
```

## File Organization

```
Training Tracker/
├── Controller/           # Business logic coordinators
├── Model/               # Observable data models and schemas
├── Views/               # SwiftUI view components
├── Timer/               # Timer implementation
├── Sound/               # Audio feedback system
├── Resources/           # JSON workout definitions
└── TrainingApp.swift    # App entry point

Training Tracker Tests/
├── Controller/          # Controller unit tests
├── Model/              # Model unit tests
└── Mock.swift          # SwiftMock testing framework
```

## Development Guidelines

### Adding New Exercise Types
1. Extend `StepType` enum with new case
2. Update `RoutineSteps.processExerciseArray()` to handle new JSON structure
3. Add view handling in `ExerciseView` or create new view component
4. Update `RoutineController.onStepCompletion()` for new step logic

### Testing with SwiftMock
- Create mock implementations using `Mock<Protocol>.create()`
- Set expectations with `.expect { }`
- Verify all expectations satisfied with `.verify()`

### JSON Workout Format
- Exercises can have `durations` (timed) or `repetitions` (count-based)
- Support for `prepTimes`, `numberOfSets`, and `restInBetween`
- Nested `exercisesGroups` allow hierarchical workout organization

### Current Workout Selection
The app loads workout routines from JSON files. The active routine is selected in `TrainingApp.swift`:
- `workoutRoutine.json` - Basic routine
- `workoutRoutine_real.json` - Full routine (currently active)
- `workoutRoutine_flo.json` - Alternative routine