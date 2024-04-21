import SwiftUI

@Observable
final class TimerModel {
    var timerStatus: TimerStatus
    var isTimerInPrep: Bool
    let prepTimeInSeconds: TimeInterval
    var prepTimeRemainingInSeconds: TimeInterval
    let exerciseTimeInSeconds: TimeInterval
    var exerciseTimeRemainingInSeconds: TimeInterval
    let delta: TimeInterval = 1/100
    var timedStepType: TimedStepType
    
    // TODO: Relay only on TimedStepType, and remove dep with Step all together
    // TODO: Extract initialization commonalities to a function: func initialize(timedStepData:)
    init(timedStepType: TimedStepType) {
        switch timedStepType {
        case let .rest(timedStepData):
            self.timerStatus = .stopped
            let prepTimeInSeconds = TimeInterval(timedStepData.prepTime)
            self.prepTimeInSeconds = prepTimeInSeconds
            let prepTimeRemainingInSeconds = prepTimeInSeconds
            self.prepTimeRemainingInSeconds = prepTimeRemainingInSeconds
            self.isTimerInPrep = (prepTimeRemainingInSeconds > 0)
            let exerciseTimeInSeconds = TimeInterval(timedStepData.duration)
            self.exerciseTimeInSeconds = exerciseTimeInSeconds
            self.exerciseTimeRemainingInSeconds = exerciseTimeInSeconds
            self.timedStepType = timedStepType
            break
        case let .exercise(timedStepData):
            self.timerStatus = .stopped
            let prepTimeInSeconds = TimeInterval(timedStepData.prepTime)
            self.prepTimeInSeconds = prepTimeInSeconds
            let prepTimeRemainingInSeconds = prepTimeInSeconds
            self.prepTimeRemainingInSeconds = prepTimeRemainingInSeconds
            self.isTimerInPrep = (prepTimeRemainingInSeconds > 0)
            let exerciseTimeInSeconds = TimeInterval(timedStepData.duration)
            self.exerciseTimeInSeconds = exerciseTimeInSeconds
            self.exerciseTimeRemainingInSeconds = exerciseTimeInSeconds
            self.timedStepType = timedStepType
            break
        }
    }
}

enum TimerStatus {
    case stopped
    case running
}
