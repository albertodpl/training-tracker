import Foundation

struct Step {
    let name: String
    let description: String?
    let stepType: StepType

    init(name: String, description: String? = nil, stepType: StepType) {
        self.name = name
        self.description = description
        self.stepType = stepType
    }
    
    func withName(_ name: String) -> Step {
        return Step(name: name, description: description, stepType: stepType)
    }

    func withDescription(_ description: String) -> Step {
        return Step(name: name, description: description, stepType: stepType)
    }

    func withStepType(_ stepType: StepType) -> Step {
        return Step(name: name, description: description, stepType: stepType)
    }
}

enum StepType: Equatable {
    case timed(TimedStepType)
    case reps(RepsStepData)
}

struct TimedStepDefinition: Equatable {
    let prepTimeInSeconds: TimeInterval
    let durationInSeconds: TimeInterval
    let delta: TimeInterval = 1/100
    let type: TimedStepTypeXXX

    init(type: TimedStepTypeXXX, prepTime: TimeInterval? = 0, duration: TimeInterval? = 0) {
        self.type = type
        self.prepTimeInSeconds = prepTime ?? 0
        self.durationInSeconds = duration ?? 0
    }
}

struct TimedStepState: Equatable {
    var timerStatus: TimerStatus
    var isTimerInPrep: Bool
    var prepTimeRemainingInSeconds: TimeInterval
    var exerciseTimeRemainingInSeconds: TimeInterval
}

enum TimedStepTypeXXX {
    case exercise
    case rest
}

enum TimedStepType: Equatable {
    case exercise(TimedStepDefinition)
    case rest(TimedStepDefinition)
    
    func getTimedStepData() -> TimedStepDefinition {
        switch self {
        case let .exercise(timedStepData):
            return timedStepData
        case let .rest(timedStepData):
            return timedStepData
        }
    }
}

struct RepsStepData: Equatable {
    let repetitions: Int

    init(repetitions: Int? = 0) {
        self.repetitions = repetitions ?? 0
    }
}
