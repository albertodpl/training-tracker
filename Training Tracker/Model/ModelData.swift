import Foundation

@Observable
class ModelData {
    let jsonRoutine: JsonRoutine = load("workoutRoutine.json")
    var currentStepIndex = 0
    var currentStep: Step = Step(name: "Initialization step, you should not see this")
    var nextExercise: Step? = nil
    var routineSteps = [Step]()
    
    init() {
        for exerciseGroup in jsonRoutine.exercisesGroups {
            dfsExerciseGroup(exerciseGroup)
        }
        currentStep = routineSteps[0]
        updateNextExercise()
    }
    
    func next() {
        if currentStepIndex < routineSteps.count - 1 {
            currentStepIndex += 1
        }
        else {
            currentStepIndex = 0
        }
        currentStep = routineSteps[currentStepIndex]
        
        updateNextExercise()
    }
    
    private func updateNextExercise() {
        var nextExerciseIndex = currentStepIndex + 1
        while (nextExerciseIndex < routineSteps.count) && (routineSteps[nextExerciseIndex].isRest) {
            nextExerciseIndex += 1
        }

        if nextExerciseIndex < routineSteps.count {
            nextExercise = routineSteps[nextExerciseIndex]
        }
        else {
            nextExercise = nil
        }
    }
    
    private func dfsExerciseGroup(_ exerciseGroup: JsonExerciseGroup) {
        if exerciseGroup.exercisesGroups == nil { // Process exercises
            if exerciseGroup.exercises == nil {
                print("ERROR: no exercise list in exercise group \(exerciseGroup.name ?? "'no exercise group name (0)'").")
            }
            else {
                print("== Exercise group: \(exerciseGroup.name ?? "'no exercise group name (1)'")")
                let exerciseSequence = processExerciseArray(exerciseGroup.exercises!)
                
                var exerciseWithRestSequence = [Step]()
                for index in 0..<exerciseSequence.count-1 {
                    exerciseWithRestSequence.append(exerciseSequence[index])
                    exerciseWithRestSequence.append(Step(name: "Rest in between: \(exerciseGroup.restInBetween ?? 0)", isRest: true))
                }
                exerciseWithRestSequence.append(exerciseSequence[exerciseSequence.count-1])
                exerciseWithRestSequence.append(Step(name: "Rest at the end: \(exerciseGroup.restAtTheEnd ?? 0)", isRest: true))
                print(exerciseWithRestSequence)
                routineSteps += exerciseWithRestSequence
            }
        }
        else {
            print("== Exercise group: \(exerciseGroup.name ?? "'no exercise group name (2)'")")
            for exerciseGroup in exerciseGroup.exercisesGroups! {
                dfsExerciseGroup(exerciseGroup)
            }
        }
    }
    
    private func processExerciseArray(_ exerciseList: [JsonExercise]) -> [Step] {
        var maxSetsCount = 0
        var exercisesSequence = [Step]()
        
        for exercise in exerciseList {
            maxSetsCount = max(maxSetsCount, exercise.numberOfSets)
        }
        
        for setIndex in 0..<maxSetsCount {
            for exerciseIndex in 0..<exerciseList.count {
                if setIndex < exerciseList[exerciseIndex].numberOfSets {
                    let step = Step(name: exerciseList[exerciseIndex].name, description: exerciseList[exerciseIndex].description)
                    exercisesSequence.append(step)
                }
            }
        }
        
        return exercisesSequence
    }
}

struct Step {
    let name: String
    let description: String?
    let isRest: Bool
    let repetitions: Int?
    
    init(name: String, description: String? = nil, isRest: Bool = false, repetitions: Int? = nil) {
        self.name = name
        self.description = description
        self.isRest = isRest
        self.repetitions = repetitions
    }
}
