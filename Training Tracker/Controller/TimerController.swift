import Foundation

protocol TimerCtrl {
    func startResume()
    func pause()
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
    
    func onTick() {
        switch timerModel.timerStatus {
        case .running:
            if timerModel.prepTimeRemainingInSeconds > 0 {
                timerModel.prepTimeRemainingInSeconds = max(0, timerModel.prepTimeRemainingInSeconds - timerModel.delta)
            } else if timerModel.exerciseTimeRemainingInSeconds > 0 {
                timerModel.exerciseTimeRemainingInSeconds = max(0, timerModel.exerciseTimeRemainingInSeconds - timerModel.delta)
            } else { // Timer reached zero.
                timerModel.timerStatus = .stopped
                onCompletion() // Call back to whover registered to get notified.
            }
        case .stopped:
            break
        }

        timerModel.isTimerInPrep = timerModel.prepTimeRemainingInSeconds > 0
    }
    
    func startResume() {
        if timerModel.exerciseTimeRemainingInSeconds > 0 {
            timerModel.timerStatus = .running
        }
    }
    
    func pause() {
        timerModel.timerStatus = .stopped
    }
}
