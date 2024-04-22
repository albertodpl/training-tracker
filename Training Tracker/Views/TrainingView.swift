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
            case let .timed(timedStepModel):
                TimerView(timedStepModel: timedStepModel)
            }
            
            Divider()
            
            switch routineModel.currentStep.stepType {
            case let .timed(timedStepModel) where timedStepModel.definition.type == .rest:
                ExerciseView(currentExercise: routineModel.currentExercise, nextExercise: routineModel.nextExercise, dim: true)
            default:
                ExerciseView(currentExercise: routineModel.currentExercise, nextExercise: routineModel.nextExercise)
            }
            
            Divider()
            Spacer()
            
            // TODO: Make it more compact, extracting commonalities.
            switch routineModel.currentStep.stepType {
            case let .timed(timedStepModel) where timedStepModel.definition.type == .rest:
                if timedStepModel.state.exerciseTimeRemainingInSeconds == 0 {
                    let _ = AudioServicesPlaySystemSound(1009) // ding ding
                }
                switch timedStepModel.state.timerStatus {
                case .running:
                    TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {
                        routineController.pauseStep()
                    })
                case .stopped:
                    TrainingButtonView(text: "Start", systemImage: "play.fill", click: {
                        routineController.startResumeStep()
                    })
                }
            case .reps:
                TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                    routineController.completeStep()
                    switch routineModel.currentStep.stepType {
                    case let .timed(timedStepModel) where timedStepModel.definition.type == .rest:
                        routineController.startResumeStep() // Starts the rest timer (one less user click)
                    default:
                        break
                    }
                })
            case let .timed(timedStepModel): // Exercise
                if timedStepModel.state.exerciseTimeRemainingInSeconds == 0 {
                    let _ = AudioServicesPlaySystemSound(1009) // ding ding
                    TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {
                        routineController.completeStep()
                        switch routineModel.currentStep.stepType {
                        case let .timed(timedStepModel) where timedStepModel.definition.type == .rest:
                            routineController.startResumeStep() // Starts the rest timer (one less user click)
                        default:
                            break
                        }
                    })
                } else {
                    switch timedStepModel.state.timerStatus {
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
