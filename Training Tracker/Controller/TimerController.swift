import Foundation

protocol TimerCtrl {
    func startResume()
    func pause()
    func registerCallback(onCompletion: @escaping () -> Void)
}

final class TimerController: TimerCtrl {
    let timerModel: TimerModel
    let periodicTimer: PeriodicTimer
    var onCompletion: () -> Void = {}
    
    init(timerModel: TimerModel, periodicTimer: PeriodicTimer, onCompletion: @escaping () -> Void) {
        self.timerModel = timerModel
        self.periodicTimer = periodicTimer
        self.onCompletion = onCompletion

        periodicTimer.registerCallback {
            self.onTick()
        }
    }

    private func onTick() {
        switch timerModel.state.timerStatus {
        case .running:
            if timerModel.state.prepTimeRemainingInSeconds > 0 {
                timerModel.state.prepTimeRemainingInSeconds = max(0, timerModel.state.prepTimeRemainingInSeconds - timerModel.definition.delta)
            } else if timerModel.state.exerciseTimeRemainingInSeconds > 0 {
                timerModel.state.exerciseTimeRemainingInSeconds = max(0, timerModel.state.exerciseTimeRemainingInSeconds - timerModel.definition.delta)
            } else { // Timer reached zero.
                timerModel.state.timerStatus = .stopped
                onCompletion() // Call back to whover registered to get notified.
            }
        case .stopped:
            break
        }

        timerModel.state.isTimerInPrep = timerModel.state.prepTimeRemainingInSeconds > 0
    }
    
    func startResume() {
        if timerModel.state.exerciseTimeRemainingInSeconds > 0 {
            timerModel.state.timerStatus = .running
        }
    }
    
    func pause() {
        timerModel.state.timerStatus = .stopped
    }
    
    func registerCallback(onCompletion: @escaping () -> Void) {
        self.onCompletion = onCompletion
    }
}
