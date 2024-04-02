import SwiftUI

struct TrainingView: View {
    @Binding var modelData: ModelData

    var body: some View {
        VStack {
            TimerView()
//                .opacity(modelData.currentStep.isRest ? 1 : 0)

//            Spacer()
            Divider()

            ExerciseView(currentStep: $modelData.currentStep, nextStep: $modelData.nextExercise)
            Divider()
            Spacer()
            
            Button("Completed") {
                modelData.next()
            }
            .buttonStyle(.borderedProminent)
            .opacity(modelData.currentStep.isRest ? 0 : 1)
        }
        .padding()
    }
}

let routine: JsonRoutine = load("workoutRoutine.json")
#Preview {
    @State var modelData = ModelData()
    return TrainingView(modelData: $modelData)
}
