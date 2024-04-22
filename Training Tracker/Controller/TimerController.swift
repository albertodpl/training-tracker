import Foundation

protocol TimerCtrl {
    func startResume()
    func pause()
    func registerCallback(onCompletion: @escaping () -> Void)
}

final class TimerController: TimerCtrl {
    let timedStepModel: TimedStepModel
    let periodicTimer: PeriodicTimer
    var onCompletion: () -> Void = {}
    
    init(timedStepModel: TimedStepModel, periodicTimer: PeriodicTimer, onCompletion: @escaping () -> Void) {
        self.timedStepModel = timedStepModel
        self.periodicTimer = periodicTimer
        self.onCompletion = onCompletion

        periodicTimer.registerCallback {
            self.onTick()
        }
    }

    private func onTick() {
        switch timedStepModel.state.timerStatus {
        case .running:
            if timedStepModel.state.prepTimeRemainingInSeconds > 0 {
                timedStepModel.state.prepTimeRemainingInSeconds = max(0, timedStepModel.state.prepTimeRemainingInSeconds - timedStepModel.definition.delta)
            } else if timedStepModel.state.exerciseTimeRemainingInSeconds > 0 {
                timedStepModel.state.exerciseTimeRemainingInSeconds = max(0, timedStepModel.state.exerciseTimeRemainingInSeconds - timedStepModel.definition.delta)
            } else { // Timer reached zero.
                timedStepModel.state.timerStatus = .stopped
                onCompletion() // Call back to whover registered to get notified.
            }
        case .stopped:
            break
        }

        timedStepModel.state.isTimerInPrep = timedStepModel.state.prepTimeRemainingInSeconds > 0
    }
    
    func startResume() {
        if timedStepModel.state.exerciseTimeRemainingInSeconds > 0 {
            timedStepModel.state.timerStatus = .running
        }
    }
    
    func pause() {
        timedStepModel.state.timerStatus = .stopped
    }
    
    func registerCallback(onCompletion: @escaping () -> Void) {
        self.onCompletion = onCompletion
    }
}
