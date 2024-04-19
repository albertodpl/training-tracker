import SwiftUI

@Observable
final class TimerModel {
    var timerStatus: TimerStatus
    var isTimerInPrep: Bool
    var prepTimeInSeconds: TimeInterval
    var prepTimeRemainingInSeconds: TimeInterval
    var exerciseTimeInSeconds: TimeInterval
    var exerciseTimeRemainingInSeconds: TimeInterval
    let delta: TimeInterval = 1/100
    var stepType: StepType
    
    init(step: Step) {
        switch step.stepType {
        case .rest(let timerStatus):
            self.timerStatus = timerStatus
            let prepTimeInSeconds = TimeInterval(step.prepTime ?? 0)
            self.prepTimeInSeconds = prepTimeInSeconds
            let prepTimeRemainingInSeconds = prepTimeInSeconds
            self.prepTimeRemainingInSeconds = prepTimeRemainingInSeconds
            self.isTimerInPrep = (prepTimeRemainingInSeconds > 0)
            let exerciseTimeInSeconds = TimeInterval(step.duration ?? 0)
            self.exerciseTimeInSeconds = exerciseTimeInSeconds
            self.exerciseTimeRemainingInSeconds = exerciseTimeInSeconds
            self.stepType = step.stepType
            break
        case .repExercise:
            self.timerStatus = .stopped
            self.prepTimeInSeconds = 0
            self.prepTimeRemainingInSeconds = 0
            self.isTimerInPrep = false
            self.exerciseTimeInSeconds = 0
            self.exerciseTimeRemainingInSeconds = 0
            self.stepType = step.stepType
            break
        case .timedExercise:
            self.timerStatus = .stopped
            let prepTimeInSeconds = TimeInterval(step.prepTime ?? 0)
            self.prepTimeInSeconds = prepTimeInSeconds
            let prepTimeRemainingInSeconds = prepTimeInSeconds
            self.prepTimeRemainingInSeconds = prepTimeRemainingInSeconds
            self.isTimerInPrep = (prepTimeRemainingInSeconds > 0)
            let exerciseTimeInSeconds = TimeInterval(step.duration ?? 0)
            self.exerciseTimeInSeconds = exerciseTimeInSeconds
            self.exerciseTimeRemainingInSeconds = exerciseTimeInSeconds
            self.stepType = step.stepType
            break
        }
    }
}

enum TimerStatus {
    case stopped
    case running
}
