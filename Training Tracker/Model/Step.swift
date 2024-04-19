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

struct TimedStepData: Equatable {
    let prepTime: Int
    let duration: Int

    init(prepTime: Int? = 0, duration: Int? = 0) {
        self.prepTime = prepTime ?? 0
        self.duration = duration ?? 0
    }
}

enum TimedStepType: Equatable {
    case exercise(TimedStepData)
    case rest(TimedStepData)
}

struct RepsStepData: Equatable {
    let repetitions: Int

    init(repetitions: Int? = 0) {
        self.repetitions = repetitions ?? 0
    }
}
