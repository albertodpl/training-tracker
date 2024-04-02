import SwiftUI

struct TrainingView: View {
    @Binding var modelData: ModelData
    
    var body: some View {
        VStack {
            switch modelData.currentStep.stepType {
            case .rest:
                TimerView()
//                    .background(.green)
            case .timedExercise:
                TimerView()
//                    .background(.orange)
            case .repExercise:
                TimerView()
                    .opacity(0.3)
            }
            
            //            Spacer()
            Divider()

            switch modelData.currentStep.stepType {
            case .rest:
                ExerciseView(currentExercise: $modelData.currentExercise, nextExercise: $modelData.nextExercise).opacity(0.3)
            case .timedExercise:
                ExerciseView(currentExercise: $modelData.currentExercise, nextExercise: $modelData.nextExercise)
            case .repExercise:
                ExerciseView(currentExercise: $modelData.currentExercise, nextExercise: $modelData.nextExercise)
            }

            Divider()
            Spacer()
            
            Button {
                modelData.next()
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .imageScale(.large)
                        .foregroundColor(.primary)
//                        .foregroundStyle(.foreground)
                        .frame(width: 250, height: 50)
                        .font(.largeTitle)
                        .padding()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

let routine: JsonRoutine = load("workoutRoutine.json")
#Preview {
    @State var modelData = ModelData()
    return TrainingView(modelData: $modelData)
}
