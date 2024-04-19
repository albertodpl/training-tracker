import SwiftUI

struct ExerciseView: View {
    let currentStep: Step
    let currentExercise: Step?
    let nextExercise: Step?

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
        }.opacity((currentStep.stepType == .timed(.rest)) ? 0.5 : 1)
    }
}

#Preview ("Long") {
    let currentStep: Step = Step(name: "Current step", description: "Description of the current step", repetitions: 8)
    let currentExercise: Step? = Step(name: "Current exercise super long, longer, and longer, what a long exercise", description: "Description of the current exercise", repetitions: 8)
    let nextExercise: Step? = Step(name: "Next exercise", description: "Description of the next exercise", repetitions: 5)
    return ExerciseView(currentStep: currentStep, currentExercise: currentExercise, nextExercise: nextExercise)
}

#Preview ("Short") {
    let currentStep: Step = Step(name: "Current step", description: "Description of the current step", repetitions: 8)
    let currentExercise: Step? = Step(name: "Current exercise", description: "Description of the current exercise", repetitions: 8)
    let nextExercise: Step? = Step(name: "Next exercise", description: "Description of the next exercise", repetitions: 5)
    return ExerciseView(currentStep: currentStep, currentExercise: currentExercise, nextExercise: nextExercise)
}
