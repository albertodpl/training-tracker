import Foundation

@Observable
class ModelData {
    let jsonRoutine: JsonRoutine = load("workoutRoutine.json")
    var currentStepIndex = 0
    var currentStep: Step = Step(name: "Initialization step; you should not see this")
    var currentExercise: Step? = nil
    var nextExercise: Step? = nil
    var routineSteps = [Step]()
    
    init() {
        for exerciseGroup in jsonRoutine.exercisesGroups {
            dfsExerciseGroup(exerciseGroup)
        }
        currentStep = routineSteps[0]
        updateCurrentAndNextExercise()
    }
    
    func next() {
        if currentStepIndex < routineSteps.count - 1 {
            currentStepIndex += 1
        }
        else { // TODO: Communiate that you completed the training.
            currentStepIndex = currentStepIndex
        }
        currentStep = routineSteps[currentStepIndex]
        
        // Add logic to manage different types of steps.
        
        updateCurrentAndNextExercise()
    }
    
    private func updateCurrentAndNextExercise() {
        var currentExerciseIndex = currentStepIndex
        while (currentExerciseIndex < routineSteps.count) && (routineSteps[currentExerciseIndex].stepType == .rest) {
            currentExerciseIndex += 1
        }
        
        if currentExerciseIndex < routineSteps.count {
            currentExercise = routineSteps[currentExerciseIndex]
        } else {
            currentExercise = nil
        }
        
        var nextExerciseIndex = currentExerciseIndex + 1
        while (nextExerciseIndex < routineSteps.count) && (routineSteps[nextExerciseIndex].stepType == .rest) {
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
                    if let restInBetween = exerciseGroup.restInBetween {
                        if restInBetween > 0 {
                            exerciseWithRestSequence.append(Step(name: "Rest in between: \(restInBetween)", duration: restInBetween, stepType: StepType.rest))
                        }
                    }
                }
                exerciseWithRestSequence.append(exerciseSequence[exerciseSequence.count-1])
                if let restAtTheEnd = exerciseGroup.restAtTheEnd {
                    if restAtTheEnd > 0 {
                        exerciseWithRestSequence.append(Step(name: "Rest at the end: \(restAtTheEnd)", duration: restAtTheEnd, stepType: StepType.rest))
                    }
                }
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
                    if let durations = exerciseList[exerciseIndex].durations {
                        let step = Step(name: exerciseList[exerciseIndex].name, description: exerciseList[exerciseIndex].description, prepTime: exerciseList[exerciseIndex].prepTimes?[setIndex], duration: durations[setIndex], stepType: .timedExercise)
                        exercisesSequence.append(step)
                    } else if let repetitions = exerciseList[exerciseIndex].repetitions {
                        let step = Step(name: exerciseList[exerciseIndex].name, description: exerciseList[exerciseIndex].description, repetitions: repetitions[setIndex], stepType: .repExercise)
                        exercisesSequence.append(step)
                    } else { // TODO: handle the case where it is not repetitions and it is not timed (malformed JSON most likely)
                        print("ERROR: no duration and no repetitions; the exercise is not defined.")
                    }
                }
            }
        }
        
        return exercisesSequence
    }
}

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
        print("\(name) ==> Prep time: \(prepTime ?? 0) + Duration: \(duration ?? 0)")
    }
}

enum StepType {
    case rest
    case repExercise
    case timedExercise
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }


    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }


    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
