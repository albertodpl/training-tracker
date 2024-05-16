import Foundation

struct Step {
    let name: String
    let description: String?
    let stepType: StepType
    let numberOfSets: Int
    let setIndex: Int

    init(name: String, description: String? = nil, stepType: StepType, numberOfSets: Int, setIndex: Int) {
        self.name = name
        self.description = description
        self.stepType = stepType
        self.numberOfSets = numberOfSets
        self.setIndex = setIndex
    }
    
    func withName(_ name: String) -> Step {
        return Step(name: name, description: description, stepType: stepType, numberOfSets: numberOfSets, setIndex: setIndex)
    }

    func withDescription(_ description: String) -> Step {
        return Step(name: name, description: description, stepType: stepType, numberOfSets: numberOfSets, setIndex: setIndex)
    }

    func withStepType(_ stepType: StepType) -> Step {
        return Step(name: name, description: description, stepType: stepType, numberOfSets: numberOfSets, setIndex: setIndex)
    }

    func withNumberOfSets(_ numberOfSets: Int) -> Step {
        return Step(name: name, description: description, stepType: stepType, numberOfSets: numberOfSets, setIndex: setIndex)
    }
}

enum StepType: Equatable {
    case timed(TimedStepModel)
    case reps(RepsStepDefinition)
}

enum TimedStepType {
    case exercise
    case rest
}

struct RepsStepDefinition: Equatable {
    let repetitions: Int

    init(repetitions: Int? = 0) {
        self.repetitions = repetitions ?? 0
    }
}
