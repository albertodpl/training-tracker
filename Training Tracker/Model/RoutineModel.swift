import Foundation

@Observable
final class RoutineModel {
    var currentStepIndex = 0
    var currentStep: Step = Step(name: "Initialization step; you should not see this") // TODO: Fix this weird initialization
    var currentExercise: Step? = nil
    var nextExercise: Step? = nil
    var routineSteps = [Step]()
    var currentStepTimerModel: TimerModel = TimerModel(step: Step(name: "Dummy step; you should not see this")) // TODO: Fix this weird initialization
    
    init(routineSteps: RoutineSteps) {
        self.routineSteps = routineSteps.routineSteps
    }
}

final class Callback {
    var callback: () -> Void = {}
}

final class RoutineController {
    let routineModel: RoutineModel
    let appLifecycleController: AppLifecycleController
    var currentStepTimerController: TimerController
    var callback = Callback()

    init(routineModel: RoutineModel, appLifecycleController: AppLifecycleController) {
        self.routineModel = routineModel
        self.appLifecycleController = appLifecycleController
        self.currentStepTimerController = TimerController(timerModel: routineModel.currentStepTimerModel, callback: callback)
        
        routineModel.currentStep = routineModel.routineSteps[0]
        updateCurrentAndNextExercise()
        self.callback.callback = self.next
    }
    
    func next() {
        if routineModel.currentStepIndex < routineModel.routineSteps.count - 1 {
            routineModel.currentStepIndex += 1
            routineModel.currentStep = routineModel.routineSteps[routineModel.currentStepIndex]
            routineModel.currentStepTimerModel = TimerModel(step: routineModel.currentStep)
            currentStepTimerController = TimerController(timerModel: routineModel.currentStepTimerModel, callback: callback)
            updateCurrentAndNextExercise()
        }
        else {
            appLifecycleController.completeTraining()
        }
    }
    
    private func updateCurrentAndNextExercise() {
        var currentExerciseIndex = routineModel.currentStepIndex
        var currentExerciseFound = false
        while (currentExerciseIndex < routineModel.routineSteps.count) && !currentExerciseFound {
            switch routineModel.routineSteps[currentExerciseIndex].stepType {
            case .rest(_):
                currentExerciseIndex += 1
            default:
                currentExerciseFound = true
            }
        }
        
        if currentExerciseIndex < routineModel.routineSteps.count {
            routineModel.currentExercise = routineModel.routineSteps[currentExerciseIndex]
        } else {
            routineModel.currentExercise = nil
        }
        
        var nextExerciseIndex = currentExerciseIndex + 1
        var nextExerciseFound = false
        while (nextExerciseIndex < routineModel.routineSteps.count) && !nextExerciseFound {
            switch routineModel.routineSteps[nextExerciseIndex].stepType {
            case .rest(_):
                nextExerciseIndex += 1
            default:
                nextExerciseFound = true
            }
        }

        if nextExerciseIndex < routineModel.routineSteps.count {
            routineModel.nextExercise = routineModel.routineSteps[nextExerciseIndex]
        }
        else {
            routineModel.nextExercise = nil
        }
    }
}

final class RoutineSteps {
    var routineSteps: [Step]

    init(jsonRoutine: JsonRoutine) {
        routineSteps = [Step]()
        
        for exerciseGroup in jsonRoutine.exercisesGroups {
            dfsExerciseGroup(exerciseGroup)
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
                            exerciseWithRestSequence.append(Step(name: "Rest in between: \(restInBetween)", duration: restInBetween, stepType: StepType.rest(.stopped)))
                        }
                    }
                }
                exerciseWithRestSequence.append(exerciseSequence[exerciseSequence.count-1])
                if let restAtTheEnd = exerciseGroup.restAtTheEnd {
                    if restAtTheEnd > 0 {
                        exerciseWithRestSequence.append(Step(name: "Rest at the end: \(restAtTheEnd)", duration: restAtTheEnd, stepType: StepType.rest(.stopped)))
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
                    } else {
                        fatalError("No duration and no repetitions for exercise \(exerciseList[exerciseIndex].name). The exercise is not defined.")
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

enum StepType: Equatable {
    case rest(TimerStatus)
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
