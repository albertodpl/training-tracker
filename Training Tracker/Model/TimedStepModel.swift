import SwiftUI

@Observable
final class TimedStepModel {
    let definition: TimedStepDefinition
    var state: TimedStepState
    
    init(timedStepDefinition: TimedStepDefinition) {
        self.definition = timedStepDefinition
        self.state = TimedStepState(timerStatus: .stopped,
                                    isTimerInPrep: (timedStepDefinition.prepTimeInSeconds > 0),
                                    prepTimeRemainingInSeconds: timedStepDefinition.prepTimeInSeconds,
                                    exerciseTimeRemainingInSeconds: timedStepDefinition.durationInSeconds)
    }
}

struct TimedStepDefinition: Equatable {
    let prepTimeInSeconds: TimeInterval
    let durationInSeconds: TimeInterval
    let delta: TimeInterval = 1/100
    let type: TimedStepTypeXXX

    init(type: TimedStepTypeXXX, prepTime: TimeInterval? = 0, duration: TimeInterval? = 0) {
        self.type = type
        self.prepTimeInSeconds = prepTime ?? 0
        self.durationInSeconds = duration ?? 0
    }
}

struct TimedStepState: Equatable {
    var timerStatus: TimerStatus
    var isTimerInPrep: Bool
    var prepTimeRemainingInSeconds: TimeInterval
    var exerciseTimeRemainingInSeconds: TimeInterval
}

enum TimerStatus {
    case stopped
    case running
}
