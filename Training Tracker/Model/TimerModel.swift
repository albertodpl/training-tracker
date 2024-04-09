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
    var timer: Timer? = nil
    var stepType: StepType
    var buttonSystemName: String
    
    init(timerStatus: TimerStatus, prepTimeInSeconds: TimeInterval = 0, prepTimeRemainingInSeconds: TimeInterval = 0, exerciseTimeInSeconds: TimeInterval, exerciseTimeRemainingInSeconds: TimeInterval, stepType: StepType = .timedExercise) {
        self.timerStatus = timerStatus
        self.prepTimeInSeconds = prepTimeInSeconds
        self.prepTimeRemainingInSeconds = prepTimeRemainingInSeconds
        self.isTimerInPrep = (prepTimeInSeconds > 0)
        self.exerciseTimeInSeconds = exerciseTimeInSeconds
        self.exerciseTimeRemainingInSeconds = exerciseTimeRemainingInSeconds
        self.stepType = stepType
        self.buttonSystemName = (timerStatus == .stopped) ? "play.fill" : "pause.fill"
    }
    
    func startTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: delta, repeats: true) { [self] _ in
            if timerStatus == .running {
                if prepTimeRemainingInSeconds > 0 {
                    prepTimeRemainingInSeconds = max(0, prepTimeRemainingInSeconds - delta)
                } else if exerciseTimeRemainingInSeconds > 0 {
                    exerciseTimeRemainingInSeconds = max(0, exerciseTimeRemainingInSeconds - delta)
                } else {
                    timerStatus = .stopped
                }
            }
            isTimerInPrep = exerciseTimeRemainingInSeconds > exerciseTimeInSeconds
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timerStatus = .stopped
    }
    
    func click() {
        switch timerStatus {
        case .stopped:
            if exerciseTimeRemainingInSeconds > 0 {
                timerStatus = .running
                startTimer()
                buttonSystemName = "pause.fill"
            } else {
                stopTimer()
                buttonSystemName = "play.fill"
            }
        case .running:
            timerStatus = .stopped
            stopTimer()
            buttonSystemName = "play.fill"
        }
    }
    
    func updateStep(currentStep: Step) {
        self.stepType = currentStep.stepType
        resetTimer(prepTimeInSeconds: currentStep.prepTime, exerciseTimeInSeconds: currentStep.duration)
        switch self.stepType {
        case .rest(.stopped):
            self.timerStatus = .stopped
            self.buttonSystemName = "play.fill"
            startTimer()
        case .rest(.running):
            self.timerStatus = .running
            self.buttonSystemName = "pause.fill"
            startTimer()
        default:
            self.timerStatus = .stopped
            self.buttonSystemName = "play.fill"
        }
        print("\(currentStep), TIMER MODEL DATA: prep time (\(self.prepTimeInSeconds)) exercise time (\(self.exerciseTimeInSeconds))")
    }
    
    func resetTimer(prepTimeInSeconds: Int?, exerciseTimeInSeconds: Int?) {
        self.prepTimeInSeconds = TimeInterval(prepTimeInSeconds ?? 0)
        self.exerciseTimeInSeconds = TimeInterval(exerciseTimeInSeconds ?? 0)
        self.prepTimeRemainingInSeconds = self.prepTimeInSeconds
        self.exerciseTimeRemainingInSeconds = self.exerciseTimeInSeconds
    }
}

enum TimerStatus {
    case stopped
    case running
}
