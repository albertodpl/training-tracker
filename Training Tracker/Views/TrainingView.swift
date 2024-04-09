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
            
            switch modelData.currentStep.stepType {
            case .rest:
                if timerModel.exerciseTimeRemainingInSeconds == 0 {
                    let _ = modelData.next()
                    let _ = timerModel.updateStep(currentStep: modelData.currentStep)
                    // TODO: Clean up. In theory, this should transition automatically, so you do not see this.
                    switch modelData.currentStep.stepType {
                    case .rest:
                        TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {
                            timerModel.click()
                        })
                    case .repExercise:
                        TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                            modelData.next()
                            timerModel.updateStep(currentStep: modelData.currentStep)
                            timerModel.click() // Starts the rest timer (one less user click)
                        })
                    case .timedExercise:
                        TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                            timerModel.click()
                        })
                    }
                } else {
                    switch timerModel.timerStatus {
                    case .running:
                        TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {
                            timerModel.click()
                        })
                    case .stopped:
                        TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                            timerModel.click()
                        })
                    }
                }
            case .repExercise:
                TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                    modelData.next()
                    timerModel.updateStep(currentStep: modelData.currentStep)
                    switch timerModel.stepType {
                    case .rest:
                        timerModel.click() // Starts the rest timer (one less user click)
                    default:
                        break
                    }
                })
            case .timedExercise:
                if timerModel.exerciseTimeRemainingInSeconds == 0 {
                    TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                        modelData.next()
                        timerModel.updateStep(currentStep: modelData.currentStep)
                        switch timerModel.stepType {
                        case .rest:
                            timerModel.click() // Starts the rest timer (one less user click)
                        default:
                            break
                        }
                    })
                } else {
                    switch timerModel.timerStatus {
                    case .running:
                        TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {
                            timerModel.click()
                        })
                    case .stopped:
                        TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                            timerModel.click()
                        })
                    }
                }
            }
        }
        .padding()
    }
}

let routine: JsonRoutine = load("workoutRoutine.json")
#Preview {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel()
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    @State var modelData = ModelData(workoutRoutine: "workoutRoutine.json", appLifecycleController: appLifecycleController)
    @State var timerModel = TimerModel(timerStatus: .stopped, prepTimeInSeconds: 5, prepTimeRemainingInSeconds: 2, exerciseTimeInSeconds: 2, exerciseTimeRemainingInSeconds: 2)
    return TrainingView(modelData: $modelData, timerModel: $timerModel)
}
