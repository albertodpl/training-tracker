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
    case reps(RepsStepDefinition)
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

struct RepsStepDefinition: Equatable {
    let repetitions: Int

    init(repetitions: Int? = 0) {
        self.repetitions = repetitions ?? 0
    }
}
