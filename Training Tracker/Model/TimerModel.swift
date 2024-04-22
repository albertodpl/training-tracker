import SwiftUI

@Observable
final class TimerModel {
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

enum TimerStatus {
    case stopped
    case running
}
