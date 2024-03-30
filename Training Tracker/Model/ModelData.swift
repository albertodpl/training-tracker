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
                for exercise in exerciseGroup.exercise! {
                    print(exercise.name)
                }
            }
        }
        else {
            print("== Exercise group: \(exerciseGroup.name ?? "'no exercise group name (2)'")")
            for exerciseGroup in exerciseGroup.exerciseGroup! {
                dfsExerciseGroup(exerciseGroup)
            }
        }
    }
}
