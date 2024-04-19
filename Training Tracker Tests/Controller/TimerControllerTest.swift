import XCTest

@testable import Training_Tracker

// TODO: use a mocking library instead
final class PeriodicTimerForUnitTesting: PeriodicTimer {
    var onTick: () -> Void = {}
    
    init(timeIntervalInSeconds interval: TimeInterval = 1/100) {
    }
    
    func registerCallback(onTick: @escaping () -> Void) {
        self.onTick = onTick
    }
}

final class TimerControllerTest: XCTestCase {
    var timerModel: TimerModel!
    var periodicTimer: PeriodicTimerForUnitTesting!
    var sut: TimerCtrl!
    
    let timedExerciseStep = Step(name: "Timed exercise step", prepTime: 5, duration: 20, stepType: .timed(.exercise))
    
    override func setUpWithError() throws {
        periodicTimer = PeriodicTimerForUnitTesting()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPauseUpdatesTimerStatusToStopped() {
        timerModel = TimerModel(step: timedExerciseStep)
        timerModel.timerStatus = .running
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.pause()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.stopped)
    }

    func testStartResumeUpdatesTimerStatusToRunningIfThereIsTimeRemaining() {
        timerModel = TimerModel(step: timedExerciseStep)
        timerModel.exerciseTimeRemainingInSeconds = 10
        timerModel.timerStatus = .stopped
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.startResume()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.running)
    }
        
    func testDoesNotResumeIfItAlreadyReachedZero() {
        timerModel = TimerModel(step: timedExerciseStep)
        timerModel.prepTimeRemainingInSeconds = 0
        timerModel.exerciseTimeRemainingInSeconds = 0
        timerModel.timerStatus = .stopped
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.startResume()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.stopped)
    }
    
    func testKeepsRunningWhenCallingStartResumeTwice() {
        timerModel = TimerModel(step: timedExerciseStep)
        timerModel.prepTimeRemainingInSeconds = 5
        timerModel.exerciseTimeRemainingInSeconds = 10
        timerModel.timerStatus = .stopped
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.startResume()
        sut.startResume()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.running)
    }

    func testKeepsPausedWhenCallingPauseTwice() {
        timerModel = TimerModel(step: timedExerciseStep)
        timerModel.prepTimeRemainingInSeconds = 5
        timerModel.exerciseTimeRemainingInSeconds = 20
        timerModel.timerStatus = .running
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.pause()
        sut.pause()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.stopped)
    }
    
    func testDecreasesOnlyExerciseTimeEachTick() {
        timerModel = TimerModel(step: timedExerciseStep)
        timerModel.prepTimeRemainingInSeconds = 0
        let exerciseTimeRemaingBeforeTick = 10.9
        let exerciseTimeRemainingAfterTick = exerciseTimeRemaingBeforeTick - timerModel.delta
        timerModel.exerciseTimeRemainingInSeconds = exerciseTimeRemaingBeforeTick
        timerModel.timerStatus = .running
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        periodicTimer.onTick()
        
        XCTAssertEqual(timerModel.exerciseTimeRemainingInSeconds, exerciseTimeRemainingAfterTick)
        XCTAssertEqual(timerModel.prepTimeRemainingInSeconds, 0)
    }
    
    func testDecreasesOnlyPrepTimeEachTick() {
        timerModel = TimerModel(step: timedExerciseStep)
        let prepTimeRemainingBeforeTick = 5.7
        let prepTimeRemainingAfterTick = prepTimeRemainingBeforeTick - timerModel.delta
        timerModel.prepTimeRemainingInSeconds = prepTimeRemainingBeforeTick
        let exerciseTimeRemaingBeforeTick = 10.9
        timerModel.exerciseTimeRemainingInSeconds = exerciseTimeRemaingBeforeTick
        timerModel.timerStatus = .running
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        periodicTimer.onTick()
        
        XCTAssertEqual(timerModel.prepTimeRemainingInSeconds, prepTimeRemainingAfterTick)
        XCTAssertEqual(timerModel.exerciseTimeRemainingInSeconds, exerciseTimeRemaingBeforeTick)
    }
        
    func testNothingChangesAfterReachingZeroWithOneCallbackCall() {
        timerModel = TimerModel(step: timedExerciseStep)
        timerModel.prepTimeRemainingInSeconds = 0.0
        timerModel.exerciseTimeRemainingInSeconds = timerModel.delta
        timerModel.timerStatus = .running
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        periodicTimer.onTick()
        periodicTimer.onTick()

        XCTAssertEqual(timerModel.prepTimeRemainingInSeconds, 0.0)
        XCTAssertEqual(timerModel.exerciseTimeRemainingInSeconds, 0.0)
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.stopped)
        
        // TODO: Check that the callback is only called once.
    }
    
    // Test cases:
    // DONE Does not run if timer is 0
    // DONE Keep running if resume() when running
    // DONE Keep paused if pause() when stopped
    // Prep time remaining cases/logic.
    // DONE Decreases the counters properly, i.e., it arrives to 0 and completes prep time in the corresponding number of ticks.
    // DONE No change happens after reaching 0.
    // Call callback() when it reaches 0.
    // Do not call callback() before reaching 0.
    // Call callback() only once, i.e., successive ticks at 0 do not trigger another callback call.
}
