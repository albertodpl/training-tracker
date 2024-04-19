import SwiftUI

struct ExerciseView: View {
    let dim: Bool
    let currentExercise: Step?
    let nextExercise: Step?
    
    init(currentExercise: Step? = nil, nextExercise: Step? = nil, dim: Bool = false) {
        self.currentExercise = currentExercise
        self.nextExercise = nextExercise
        self.dim = dim
    }

    var body: some View {
        VStack {
            VStack {
                Text(currentExercise?.name ?? "")
                    .font(.title)
                if let description = currentExercise?.description {
                    Text(description)
                        .font(.title2)
                }
            }
            
            Divider()
            
            if let nextStep = nextExercise {
                Text("Next up: \(nextStep.name)")
                    .font(.title3)
                    .opacity(0.5)
                    .padding([.top, .bottom])
            }
        }.opacity(dim ? 0.5 : 1)
    }
}

#Preview ("Long") {
    let currentExercise: Step? = Step(name: "Current exercise super long, longer, and longer, what a long exercise", description: "Description of the current exercise", stepType: .reps(RepsStepData(repetitions: 8)))
    let nextExercise: Step? = Step(name: "Next exercise", description: "Description of the next exercise", stepType: .reps(RepsStepData(repetitions: 12)))
    return ExerciseView(currentExercise: currentExercise, nextExercise: nextExercise)
}

#Preview ("Short") {
    let currentExercise: Step? = Step(name: "Current exercise", description: "Description of the current exercise", stepType: .reps(RepsStepData(repetitions: 8)))
    let nextExercise: Step? = Step(name: "Next exercise", description: "Description of the next exercise", stepType: .reps(RepsStepData(repetitions: 12)))
    return ExerciseView(currentExercise: currentExercise, nextExercise: nextExercise)
}

#Preview ("Short") {
    let currentExercise: Step? = Step(name: "Current exercise", description: "Description of the current exercise", stepType: .reps(RepsStepData(repetitions: 8)))
    let nextExercise: Step? = Step(name: "Next exercise", description: "Description of the next exercise", stepType: .reps(RepsStepData(repetitions: 12)))
    return ExerciseView(currentExercise: currentExercise, nextExercise: nextExercise, dim: true)
}
