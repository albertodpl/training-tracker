import SwiftUI

struct ExerciseView: View {
    @Binding var currentStep: Step
    @Binding var nextStep: Step?
    
    // TODO: Extract to View
    private func currentExerciseRepsAndNameView(repetitions: Int?, stepName: String) -> some View {
        if let repetitions = repetitions {
            return Text("x\(repetitions) - \(stepName)")
        }
        else {
            return Text(stepName)
        }
    }
    var body: some View {
        VStack {
            VStack {
                currentExerciseRepsAndNameView(repetitions: currentStep.repetitions, stepName: currentStep.name)
                    .font(.title)
                if let description = currentStep.description {
                    Text(description)
                        .font(.title2)
                    
                }
            }
            .padding(.bottom)
            .opacity(currentStep.isRest ? 0 : 1)
            if let nextStep = nextStep {
                Text("Next up: \(nextStep.name)")
                    .font(.title3)
                    .opacity(0.5)
            }
        }
    }
                     

}

#Preview {
    @State var currentStep = Step(name: "Current step", description: "Description of the current step", repetitions: 8)
    @State var nextStep: Step? = Step(name: "Next step", description: "Description of the next step", repetitions: 5)
    return ExerciseView(currentStep: $currentStep, nextStep: $nextStep)
}
