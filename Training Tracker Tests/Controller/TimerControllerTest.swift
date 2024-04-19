import XCTest

@testable import Training_Tracker

// TODO: use a mocking library instead
final class PeriodicTimerForUnitTesting: PeriodicTimer {
    init(timeIntervalInSeconds interval: TimeInterval = 1/100) {
    }
    
    func registerCallback(onTick: @escaping () -> Void) {
    }
}

final class TimerControllerTest: XCTestCase {
    var timerModel: TimerModel!
    var periodicTimer: PeriodicTimer!
    var sut: TimerCtrl!
    
//    let stepWithEverything = Step(name: "Step with everything", description: "Step description", repetitions: 5, prepTime: 5, duration: 20, stepType: .timedExercise)
    let timedExerciseStep = Step(name: "Timed exercise step", prepTime: 5, duration: 20, stepType: .timedExercise)
    let restStep = Step(name: "Rest step", duration: 90, stepType: .timedExercise)
    
    override func setUpWithError() throws {
        periodicTimer = PeriodicTimerForUnitTesting()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func pauseUpdatesTimerStatusToStopped(_ step: Step) {
        timerModel = TimerModel(step: step)
        timerModel.timerStatus = .running
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.pause()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.stopped)
    }

    func testPauseUpdatesTimerStatusToStoppedForTimedExerciseStep() {
        pauseUpdatesTimerStatusToStopped(timedExerciseStep)
    }

    func testPauseUpdatesTimerStatusToStoppedForRestStep() {
        pauseUpdatesTimerStatusToStopped(restStep)
    }

    private func startResumeUpdatesTimerStatusToRunningIfThereIsTimeRemaining(_ step: Step) {
        timerModel = TimerModel(step: step)
        timerModel.exerciseTimeRemainingInSeconds = 10
        timerModel.timerStatus = .stopped
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.startResume()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.running)
    }
    
    func testStartResumeUpdatesTimerStatusToRunningIfThereIsTimeRemainingForTimedExerciseStep() {
        startResumeUpdatesTimerStatusToRunningIfThereIsTimeRemaining(timedExerciseStep)
    }

    func testStartResumeUpdatesTimerStatusToRunningIfThereIsTimeRemainingForRestStep() {
        startResumeUpdatesTimerStatusToRunningIfThereIsTimeRemaining(restStep)
    }
        
    private func doesNotResumeIfItAlreadyReachedZero(_ step: Step) {
        timerModel = TimerModel(step: step)
        timerModel.prepTimeRemainingInSeconds = 0
        timerModel.exerciseTimeRemainingInSeconds = 0
        timerModel.timerStatus = .stopped
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.startResume()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.stopped)
    }
    
    func testDoesNotResumeIfItAlreadyReachedZeroForTimedExerciseStep() {
        doesNotResumeIfItAlreadyReachedZero(timedExerciseStep)
    }

    func testDoesNotResumeIfItAlreadyReachedZeroForRestStep() {
        doesNotResumeIfItAlreadyReachedZero(restStep)
    }
    
    // Test cases:
    // DONE Does not run if timer is 0
    // Keep running if resume() when running
    // Keep paused if pause() when stopped
    // Call callback() when it reaches 0.
    // Do not call callback() before reaching 0.
    // Call callback() only once, i.e., successive ticks at 0 does not trigger another callback call.
    // Prep time remaining cases/logic.
    // Decreases the counters properly, i.e., it arrives to 0 and completes prep time in the corresponding number of ticks.
}
