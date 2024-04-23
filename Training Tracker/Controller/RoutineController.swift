import Foundation

protocol RoutineCtrl {
    func onStepCompletion()
    func onStepStart()
    func pauseStep()
    func startResumeStep()
}

final class RoutineController: RoutineCtrl {
    private let routineModel: RoutineModel
    private let appLifecycleController: AppLifecycleController
    private let periodicTimerBuilder: () -> PeriodicTimer
    private var currentStepTimerController: TimerCtrl? = nil
    private let soundPlayer: SoundPlyr

    init(routineModel: RoutineModel, appLifecycleController: AppLifecycleController, periodicTimerBuilder: @escaping () -> PeriodicTimer, soundPlayer: SoundPlyr) {
        self.routineModel = routineModel
        self.appLifecycleController = appLifecycleController
        self.periodicTimerBuilder = periodicTimerBuilder
        self.soundPlayer = soundPlayer
        
        // TODO: Extract to a function and share with func completeStep(). Is it possible?
        switch routineModel.currentStep.stepType {
        case let .timed(timedStepModel):
            self.currentStepTimerController = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimerBuilder(), onCompletion: self.onStepCompletion, onStart: self.onStepStart)
        case .reps(_):
            self.currentStepTimerController = nil
        }
        
        updateCurrentAndNextExercise()
    }
    
    func onStepCompletion() {
        switch routineModel.currentStep.stepType {
        case let .timed(timedStepModel) where timedStepModel.definition.type == .exercise:
            soundPlayer.endExercise()
        case .timed:
            soundPlayer.endPause()
        default:
            break
        }
        if routineModel.currentStepIndex < routineModel.routineSteps.count - 1 {
            routineModel.currentStepIndex += 1
            routineModel.currentStep = routineModel.routineSteps[routineModel.currentStepIndex]

            // TODO: Extract and share with init
            switch routineModel.currentStep.stepType {
            case let .timed(timedStepModel):
                self.currentStepTimerController = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimerBuilder(), onCompletion: self.onStepCompletion, onStart: self.onStepStart)
            case .reps(_):
                self.currentStepTimerController = nil
            }

            updateCurrentAndNextExercise()
        }
        else {
            appLifecycleController.completeTraining()
        }
    }
    
    func onStepStart() {
        switch routineModel.currentStep.stepType {
        case let .timed(timedStepModel) where timedStepModel.definition.type == .exercise:
            soundPlayer.startExercise()
        default:
            break
        }
    }

    func pauseStep() {
        currentStepTimerController?.pause()
    }
    
    func startResumeStep() {
        currentStepTimerController?.startResume()
    }
    
    // Finds the next two exercises from the current position, ignoring rest steps
    private func updateCurrentAndNextExercise() {
        var currentExerciseIndex = routineModel.currentStepIndex
        var currentExerciseFound = false
        while (currentExerciseIndex < routineModel.routineSteps.count) && !currentExerciseFound {
            switch routineModel.routineSteps[currentExerciseIndex].stepType {
            case let .timed(timedStepModel) where timedStepModel.definition.type == .rest:
                currentExerciseIndex += 1
            default:
                currentExerciseFound = true
            }
        }
        
        if currentExerciseIndex < routineModel.routineSteps.count {
            routineModel.currentExercise = routineModel.routineSteps[currentExerciseIndex]
        } else {
            routineModel.currentExercise = nil
        }
        
        var nextExerciseIndex = currentExerciseIndex + 1
        var nextExerciseFound = false
        while (nextExerciseIndex < routineModel.routineSteps.count) && !nextExerciseFound {
            switch routineModel.routineSteps[nextExerciseIndex].stepType {
            case let .timed(timedStepModel) where timedStepModel.definition.type == .rest:
                nextExerciseIndex += 1
            default:
                nextExerciseFound = true
            }
        }

        if nextExerciseIndex < routineModel.routineSteps.count {
            routineModel.nextExercise = routineModel.routineSteps[nextExerciseIndex]
        }
        else {
            routineModel.nextExercise = nil
        }
    }
}
