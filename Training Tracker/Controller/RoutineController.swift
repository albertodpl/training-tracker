import Foundation

protocol RoutineCtrl {
    func completeStep()
    func pauseStep()
    func startResumeStep()
}

final class RoutineController: RoutineCtrl {
    let routineModel: RoutineModel
    let appLifecycleController: AppLifecycleController
    let periodicTimerBuilder: () -> PeriodicTimer
    var currentStepTimerController: TimerCtrl? = nil

    init(routineModel: RoutineModel, appLifecycleController: AppLifecycleController, periodicTimerBuilder: @escaping () -> PeriodicTimer) {
        self.routineModel = routineModel
        self.appLifecycleController = appLifecycleController
        self.periodicTimerBuilder = periodicTimerBuilder

        routineModel.currentStepIndex = 0
        routineModel.currentStep = routineModel.routineSteps[routineModel.currentStepIndex]
        routineModel.currentStepTimerModel = TimerModel(step: routineModel.currentStep)
        
        self.currentStepTimerController = TimerController(timerModel: routineModel.currentStepTimerModel, periodicTimer: periodicTimerBuilder(), onCompletion: self.completeStep)
        
        updateCurrentAndNextExercise()
    }
    
    func completeStep() {
        if routineModel.currentStepIndex < routineModel.routineSteps.count - 1 {
            routineModel.currentStepIndex += 1
            routineModel.currentStep = routineModel.routineSteps[routineModel.currentStepIndex]
            routineModel.currentStepTimerModel = TimerModel(step: routineModel.currentStep)
            currentStepTimerController = TimerController(timerModel: routineModel.currentStepTimerModel, periodicTimer: periodicTimerBuilder(), onCompletion: self.completeStep)
            updateCurrentAndNextExercise()
        }
        else {
            appLifecycleController.completeTraining()
        }
    }
    
    func pauseStep() {
        currentStepTimerController?.pause()
    }
    
    func startResumeStep() {
        currentStepTimerController?.startResume()
    }
    
    private func updateCurrentAndNextExercise() {
        var currentExerciseIndex = routineModel.currentStepIndex
        var currentExerciseFound = false
        while (currentExerciseIndex < routineModel.routineSteps.count) && !currentExerciseFound {
            switch routineModel.routineSteps[currentExerciseIndex].stepType {
            case .rest(_):
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
            case .rest(_):
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
