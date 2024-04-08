import SwiftUI

struct TrainingView: View {
    @Binding var modelData: ModelData
    @Binding var timerModel: TimerModel
    
    var body: some View {
        VStack {
            TimerView(timerModel: $timerModel)
            
            Divider()
            
            ExerciseView(currentStep: $modelData.currentStep, currentExercise: $modelData.currentExercise, nextExercise: $modelData.nextExercise)
            
            Divider()
            Spacer()
            
            // For start and stop during rest and timed exercises:
            //  Image(systemName: isRunning ? "stop.fill" : "play.fill")
            switch modelData.currentStep.stepType {
            case .rest:
                Button {
                    if timerModel.exerciseTimeRemainingInSeconds == 0 {
                        modelData.next()
                        timerModel.updateStep(currentStep: modelData.currentStep)
                    } else {
                        timerModel.click()
                    }
                } label: {
                    HStack {
                        Image(systemName: (timerModel.exerciseTimeRemainingInSeconds > 0) ? timerModel.buttonSystemName : "checkmark")
                            .imageScale(.large)
                        //                            .foregroundColor(.primary)
                            .foregroundStyle(.foreground)
                            .frame(width: 250, height: 50)
                            .font(.largeTitle)
                            .padding()
                    }
                }
                .buttonStyle(.borderedProminent)
            case .repExercise:
                Button {
                    modelData.next()
                    timerModel.updateStep(currentStep: modelData.currentStep)
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                            .imageScale(.large)
                        //                            .foregroundColor(.primary)
                            .foregroundStyle(.foreground)
                            .frame(width: 250, height: 50)
                            .font(.largeTitle)
                            .padding()
                    }
                }
                .buttonStyle(.borderedProminent)
            case .timedExercise:
                Button {
                    if timerModel.exerciseTimeRemainingInSeconds == 0 {
                        modelData.next()
                        timerModel.updateStep(currentStep: modelData.currentStep)
                    } else {
                        timerModel.click()
                    }
                } label: {
                    HStack {
                        Image(systemName: (timerModel.exerciseTimeRemainingInSeconds > 0) ? timerModel.buttonSystemName : "checkmark")
                            .imageScale(.large)
                        //                            .foregroundColor(.primary)
                            .foregroundStyle(.foreground)
                            .frame(width: 250, height: 50)
                            .font(.largeTitle)
                            .padding()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

let routine: JsonRoutine = load("workoutRoutine.json")
#Preview {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel()
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    @State var modelData = ModelData(appLifecycleController: appLifecycleController)
    @State var timerModel = TimerModel(timerStatus: .stopped, prepTimeInSeconds: 5, prepTimeRemainingInSeconds: 2, exerciseTimeInSeconds: 75, exerciseTimeRemainingInSeconds: 75)
    return TrainingView(modelData: $modelData, timerModel: $timerModel)
}
