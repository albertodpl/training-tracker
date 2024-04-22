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
            switch routineModel.currentStep.stepType {
            case let .reps(repsStepData):
                RepsView(repsStepData: repsStepData)
            case .timed(_):
                // TODO: Fix the forced unwrapping of the timerModel
                TimerView(timedStepModel: routineModel.currentStepTimedStepModel!)
            }
            
            Divider()
            
            switch routineModel.currentStep.stepType {
            case .timed(.rest(_)):
                ExerciseView(currentExercise: routineModel.currentExercise, nextExercise: routineModel.nextExercise, dim: true)
            default:
                ExerciseView(currentExercise: routineModel.currentExercise, nextExercise: routineModel.nextExercise)
            }
            
            Divider()
            Spacer()
            
            // TODO: Make it more compact, extracting commonalities.
            switch routineModel.currentStep.stepType {
            case .timed(.rest):
                // TODO: Maybe pass the state of the timer in the corresponding enum
                if routineModel.currentStepTimedStepModel?.state.exerciseTimeRemainingInSeconds == 0 {
                    let _ = AudioServicesPlaySystemSound(1009) // ding ding
                }
                switch routineModel.currentStepTimedStepModel?.state.timerStatus {
                case .running:
                    TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {
                        routineController.pauseStep()
                    })
                case .stopped:
                    TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                        routineController.startResumeStep()
                    })
                case .none:
                    fatalError(".timed(.rest) with no TimerModel.")
                }
            case .reps:
                TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                    routineController.completeStep()
                    switch routineModel.currentStep.stepType {
                    case .timed(.rest):
                        routineController.startResumeStep() // Starts the rest timer (one less user click)
                    default:
                        break
                    }
                })
            case .timed(.exercise):
                if routineModel.currentStepTimedStepModel?.state.exerciseTimeRemainingInSeconds == 0 {
                    let _ = AudioServicesPlaySystemSound(1009) // ding ding
                    TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                        routineController.completeStep()
                        switch routineModel.currentStep.stepType {
                        case .timed(.rest):
                            routineController.startResumeStep() // Starts the rest timer (one less user click)
                        default:
                            break
                        }
                    })
                } else {
                    switch routineModel.currentStepTimedStepModel?.state.timerStatus {
                    case .running:
                        TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {
                            routineController.pauseStep()
                        })
                    case .stopped:
                        TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                            routineController.startResumeStep()
                        })
                    case .none:
                        fatalError(".timed(.exercise) with no TimerModel.")
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
