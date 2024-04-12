import SwiftUI
import AudioToolbox

struct TrainingView: View {
    let routineModel: RoutineModel
    let routineController: RoutineController
    
    init(routineModel: RoutineModel, routineController: RoutineController) {
        self.routineModel = routineModel
        self.routineController = routineController
    }
    
    var body: some View {
        VStack {
            TimerView(timerModel: routineModel.currentStepTimerModel)
            
            Divider()
            
            ExerciseView(currentStep: routineModel.currentStep, currentExercise: routineModel.currentExercise, nextExercise: routineModel.nextExercise)
            
            Divider()
            Spacer()
            
            // TODO: Make it more compact, extracting commonalities.
            switch routineModel.currentStep.stepType {
            case .rest:
                if routineModel.currentStepTimerModel.exerciseTimeRemainingInSeconds == 0 {
                    let _ = AudioServicesPlaySystemSound(1009) // ding ding
                }
                switch routineModel.currentStepTimerModel.timerStatus {
                case .running:
                    TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {
                        routineController.currentStepTimerController.pause()
                    })
                case .stopped:
                    TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                        routineController.currentStepTimerController.play()
                    })
                }
            case .repExercise:
                TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                    routineController.next()
                    switch routineModel.currentStepTimerModel.stepType {
                    case .rest:
                        routineController.currentStepTimerController.play() // Starts the rest timer (one less user click)
                    default:
                        break
                    }
                })
            case .timedExercise:
                if routineModel.currentStepTimerModel.exerciseTimeRemainingInSeconds == 0 {
                    let _ = AudioServicesPlaySystemSound(1009) // ding ding
                    TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                        routineController.next()
                        switch routineModel.currentStepTimerModel.stepType {
                        case .rest:
                            routineController.currentStepTimerController.play() // Starts the rest timer (one less user click)
                        default:
                            break
                        }
                    })
                } else {
                    switch routineModel.currentStepTimerModel.timerStatus {
                    case .running:
                        TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {
                            routineController.currentStepTimerController.pause()
                        })
                    case .stopped:
                        TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                            routineController.currentStepTimerController.play()
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
    let jsonRoutine: JsonRoutine = load("workoutRoutine.json")
    let routineSteps = RoutineSteps(jsonRoutine: jsonRoutine)
    @State var routineModel = RoutineModel(routineSteps: routineSteps)
    let routineController = RoutineController(routineModel: routineModel, appLifecycleController: appLifecycleController)
    return TrainingView(routineModel: routineModel, routineController: routineController)
}
