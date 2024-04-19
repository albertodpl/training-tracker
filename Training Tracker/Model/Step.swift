import Foundation

struct Step {
    let name: String
    let description: String?
    let repetitions: Int?
    let prepTime: Int?
    let duration: Int?
    let stepType: StepType

    init(name: String, description: String? = nil, repetitions: Int? = nil, prepTime: Int? = nil, duration: Int? = nil, stepType: StepType = StepType.repExercise) {
        self.name = name
        self.description = description
        self.repetitions = repetitions
        self .prepTime = prepTime
        self.duration = duration
        self.stepType = stepType
    }
    
    func withName(_ name: String) -> Step {
        return Step(name: name, description: description, repetitions: repetitions, prepTime: prepTime, duration: duration, stepType: stepType)
    }

    func withDescription(_ description: String) -> Step {
        return Step(name: name, description: description, repetitions: repetitions, prepTime: prepTime, duration: duration, stepType: stepType)
    }

    func withRepetitions(_ repetitions: Int) -> Step {
        return Step(name: name, description: description, repetitions: repetitions, prepTime: prepTime, duration: duration, stepType: stepType)
    }

    func withPrepTime(_ prepTime: Int) -> Step {
        return Step(name: name, description: description, repetitions: repetitions, prepTime: prepTime, duration: duration, stepType: stepType)
    }

    func withDuration(_ duration: Int) -> Step {
        return Step(name: name, description: description, repetitions: repetitions, prepTime: prepTime, duration: duration, stepType: stepType)
    }

    func withStepType(_ stepType: StepType) -> Step {
        return Step(name: name, description: description, repetitions: repetitions, prepTime: prepTime, duration: duration, stepType: stepType)
    }
}

enum StepType: Equatable {
    case rest(TimerStatus)
    case repExercise
    case timedExercise
}
