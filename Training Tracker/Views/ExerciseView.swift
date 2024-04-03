import SwiftUI

struct ExerciseView: View {
    @Binding var currentStep: Step
    @Binding var currentExercise: Step?
    @Binding var nextExercise: Step?
    
    // TODO: Extract to View
    private func currentExerciseRepsAndNameView(repetitions: Int?, exerciseName: String?) -> some View {
        if let repetitions = repetitions {
            return Text("x\(repetitions) - \(exerciseName ?? "")")
        }
        else {
            return Text(exerciseName ?? "")
        }
    }
    var body: some View {
        VStack {
            VStack {
                currentExerciseRepsAndNameView(repetitions: currentExercise?.repetitions, exerciseName: currentExercise?.name)
                    .font(.title)
                if let description = currentExercise?.description {
                    Text(description)
                        .font(.title2)
                    
                }
            }
            .padding([.top, .bottom])
            .opacity(currentExercise?.stepType == .rest ? 0 : 1)
            
            Divider()
            
            if let nextStep = nextExercise {
                Text("Next up: \(nextStep.name)")
                    .font(.title3)
                    .opacity(0.5)
                    .padding([.top, .bottom])
            }
        }.opacity((currentStep.stepType == .rest) ? 0.3 : 1)
    }
                     

}

#Preview {
    @State var currentStep: Step = Step(name: "Current step", description: "Description of the current step", repetitions: 8)
    @State var currentExercise: Step? = Step(name: "Current exercise", description: "Description of the current exercise", repetitions: 8)
    @State var nextExercise: Step? = Step(name: "Next exercise", description: "Description of the next exercise", repetitions: 5)
    return ExerciseView(currentStep: $currentStep, currentExercise: $currentExercise, nextExercise: $nextExercise)
}
