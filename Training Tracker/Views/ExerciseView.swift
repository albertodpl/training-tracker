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
    
    private func formattedTime(durationInSeconds: TimeInterval) -> String {
        let durationInSecondsTruncated = Int(durationInSeconds)
        
        
        let minutes = durationInSecondsTruncated / 60
        let seconds = durationInSecondsTruncated % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func formattedReps(repetitions: Int) -> String {
        return String(format: "x%d", repetitions)
    }

    var body: some View {
        VStack {
            VStack {
                HStack {
                    if let currentExercise = currentExercise {
                        switch currentExercise.stepType {
                        case .timed(let timedStepModel):
                            Text(formattedTime(durationInSeconds: timedStepModel.definition.durationInSeconds))
                                .font(.title)
                        case .reps(let repsStepDefinition):
                            Text(formattedReps(repetitions: repsStepDefinition.repetitions))
                                .font(.title)
                        }
                        Text(currentExercise.name)
                            .font(.title)
                    } else {
                        Text("")
                            .font(.title)
                    }
                }
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
    let currentExercise: Step? = Step(name: "Current exercise super long, longer, and longer, what a long exercise", description: "Description of the current exercise", stepType: .reps(RepsStepDefinition(repetitions: 8)))
    let nextExercise: Step? = Step(name: "Next exercise", description: "Description of the next exercise", stepType: .reps(RepsStepDefinition(repetitions: 12)))
    return ExerciseView(currentExercise: currentExercise, nextExercise: nextExercise)
}

#Preview ("Short") {
    let currentExercise: Step? = Step(name: "Current exercise", description: "Description of the current exercise", stepType: .reps(RepsStepDefinition(repetitions: 8)))
    let nextExercise: Step? = Step(name: "Next exercise", description: "Description of the next exercise", stepType: .reps(RepsStepDefinition(repetitions: 12)))
    return ExerciseView(currentExercise: currentExercise, nextExercise: nextExercise)
}

#Preview ("Short, dim true") {
    let currentExercise: Step? = Step(name: "Current exercise", description: "Description of the current exercise", stepType: .reps(RepsStepDefinition(repetitions: 8)))
    let nextExercise: Step? = Step(name: "Next exercise", description: "Description of the next exercise", stepType: .reps(RepsStepDefinition(repetitions: 12)))
    return ExerciseView(currentExercise: currentExercise, nextExercise: nextExercise, dim: true)
}
