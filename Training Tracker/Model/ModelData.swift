import Foundation

@Observable
class ModelData {
    let routine: Routine = load("workoutRoutine.json")
    var currentStep = 0
    
    init() {
        for exerciseGroup in routine.exerciseGroup {
            dfsExerciseGroup(exerciseGroup)
        }
    }
    
    func dfsExerciseGroup(_ exerciseGroup: ExerciseGroup) {
        if exerciseGroup.exerciseGroup == nil { // Process exercises
            if exerciseGroup.exercise == nil {
                print("ERROR: no exercise list in exercise group \(exerciseGroup.name ?? "'no exercise group name (0)'").")
            }
            else {
                print("== Exercise group: \(exerciseGroup.name ?? "'no exercise group name (1)'")")
                var exerciseSequence = processExerciseArray(exerciseGroup.exercise!)
                
                var exerciseWithRestSequence = [String]()
                for index in 0..<exerciseSequence.count-1 {
                    exerciseWithRestSequence.append(exerciseSequence[index])
                    exerciseWithRestSequence.append("\(exerciseGroup.restInBetween ?? 0)")
                }
                exerciseWithRestSequence.append(exerciseSequence[exerciseSequence.count-1])
                exerciseWithRestSequence.append("\(exerciseGroup.restAtTheEnd ?? 0)")
                print(exerciseWithRestSequence)
            }
        }
        else {
            print("== Exercise group: \(exerciseGroup.name ?? "'no exercise group name (2)'")")
            for exerciseGroup in exerciseGroup.exerciseGroup! {
                dfsExerciseGroup(exerciseGroup)
            }
        }
    }
    
    func processExerciseArray(_ exerciseList: [Exercise]) -> [String] {
        var maxSetsCount = 0
        var exercisesSequence = [String]()
        
        for exercise in exerciseList {
            maxSetsCount = max(maxSetsCount, exercise.numberOfSets)
        }
        
        for setIndex in 0..<maxSetsCount {
            for exerciseIndex in 0..<exerciseList.count {
                if setIndex < exerciseList[exerciseIndex].numberOfSets {
                    exercisesSequence.append(exerciseList[exerciseIndex].name)
                }
            }
        }
        
        return exercisesSequence
    }
}
