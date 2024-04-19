import SwiftUI
import AudioToolbox

struct TrainingView: View {
    let routineModel: RoutineModel
    let routineController: RoutineCtrl
    
    init(routineModel: RoutineModel, routineController: RoutineCtrl) {
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
                        routineController.pauseStep()
                    })
                case .stopped:
                    TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                        routineController.startResumeStep()
                    })
                }
            case .repExercise:
                TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                    routineController.completeStep()
                    switch routineModel.currentStepTimerModel.stepType {
                    case .rest:
                        routineController.startResumeStep() // Starts the rest timer (one less user click)
                    default:
                        break
                    }
                })
            case .timedExercise:
                if routineModel.currentStepTimerModel.exerciseTimeRemainingInSeconds == 0 {
                    let _ = AudioServicesPlaySystemSound(1009) // ding ding
                    TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                        routineController.completeStep()
                        switch routineModel.currentStepTimerModel.stepType {
                        case .rest:
                            routineController.startResumeStep() // Starts the rest timer (one less user click)
                        default:
                            break
                        }
                    })
                } else {
                    switch routineModel.currentStepTimerModel.timerStatus {
                    case .running:
                        TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {
                            routineController.pauseStep()
                        })
                    case .stopped:
                        TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                            routineController.startResumeStep()
                        })
                    }
                }
            }
        }
        .padding()
    }
}

let routine: JsonRoutine = JsonRoutine.load("workoutRoutine.json")
#Preview {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel(appLifecycleStatus: .trainingStarted)
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    let jsonRoutine: JsonRoutine = JsonRoutine.load("workoutRoutine.json")
    let routineSteps = RoutineSteps(jsonRoutine: jsonRoutine)
    @State var routineModel = RoutineModel(routineSteps: routineSteps)
    let periodicTimer = PeriodicTimerWrapper()
    let routineController = RoutineController(routineModel: routineModel, appLifecycleController: appLifecycleController, periodicTimerBuilder: { periodicTimer })
    return TrainingView(routineModel: routineModel, routineController: routineController)
}
