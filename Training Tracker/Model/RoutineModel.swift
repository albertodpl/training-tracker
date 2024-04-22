import Foundation

@Observable
final class RoutineModel {
    var currentStepIndex = 0
    var currentStep: Step = Step(name: "Initialization step; you should not see this", stepType: .reps(RepsStepData(repetitions: 0))) // TODO: Fix this weird initialization
    var currentExercise: Step? = nil
    var nextExercise: Step? = nil
    var routineSteps = [Step]()
    var currentStepTimerModel: TimerModel? = nil
    
    init(routineSteps: RoutineSteps) {
        self.routineSteps = routineSteps.routineSteps
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
                            exerciseWithRestSequence.append(Step(name: "Rest in between: \(restInBetween)", stepType: StepType.timed(.rest(TimedStepDefinition(type: .rest, duration: TimeInterval(restInBetween))))))
                        }
                    }
                }
                exerciseWithRestSequence.append(exerciseSequence[exerciseSequence.count-1])
                if let restAtTheEnd = exerciseGroup.restAtTheEnd {
                    if restAtTheEnd > 0 {
                        exerciseWithRestSequence.append(Step(name: "Rest at the end: \(restAtTheEnd)", stepType: StepType.timed(.rest(TimedStepDefinition(type: .rest, duration: TimeInterval(restAtTheEnd))))))
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
                        let step = Step(name: exerciseList[exerciseIndex].name, description: exerciseList[exerciseIndex].description, stepType: .timed(.exercise(TimedStepDefinition(type: .exercise, prepTime: toOptionalTimeInterval(exerciseList[exerciseIndex].prepTimes?[setIndex]), duration: toOptionalTimeInterval(durations[setIndex])))))
                        exercisesSequence.append(step)
                    } else if let repetitions = exerciseList[exerciseIndex].repetitions {
                        let step = Step(name: exerciseList[exerciseIndex].name, description: exerciseList[exerciseIndex].description, stepType: .reps(RepsStepData(repetitions: repetitions[setIndex])))
                        exercisesSequence.append(step)
                    } else {
                        fatalError("No duration and no repetitions for exercise \(exerciseList[exerciseIndex].name). The exercise is not defined.")
                    }
                }
            }
        }
                
        return exercisesSequence
    }
    
    private func toOptionalTimeInterval(_ timeInterval: Int?) -> TimeInterval? {
        if let timeInterval = timeInterval {
            return TimeInterval(timeInterval)
        } else {
            return nil
        }
    }
}
