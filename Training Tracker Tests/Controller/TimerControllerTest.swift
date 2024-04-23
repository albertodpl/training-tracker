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
    var timedStepModel: TimedStepModel!
    var periodicTimer: PeriodicTimerForUnitTesting!
    var sut: TimerCtrl!
    
    let timedStepData = TimedStepDefinition(type: .exercise, prepTime: 5, duration: 20)
    
    override func setUpWithError() throws {
        periodicTimer = PeriodicTimerForUnitTesting()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPauseUpdatesTimerStatusToStopped() {
        timedStepModel = TimedStepModel(timedStepDefinition: timedStepData)
        timedStepModel.state.timerStatus = .running
        sut = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimer, onCompletion: {}, onStart: {})
        
        sut.pause()
        
        XCTAssertEqual(timedStepModel.state.timerStatus, TimerStatus.stopped)
    }

    func testStartResumeUpdatesTimerStatusToRunningIfThereIsTimeRemaining() {
        timedStepModel = TimedStepModel(timedStepDefinition: timedStepData)
        timedStepModel.state.exerciseTimeRemainingInSeconds = 10
        timedStepModel.state.timerStatus = .stopped
        
        sut = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimer, onCompletion: {}, onStart: {})
        
        sut.startResume()
        
        XCTAssertEqual(timedStepModel.state.timerStatus, TimerStatus.running)
    }
        
    func testDoesNotResumeIfItAlreadyReachedZero() {
        timedStepModel = TimedStepModel(timedStepDefinition: timedStepData)
        timedStepModel.state.prepTimeRemainingInSeconds = 0
        timedStepModel.state.exerciseTimeRemainingInSeconds = 0
        timedStepModel.state.timerStatus = .stopped
        
        sut = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimer, onCompletion: {}, onStart: {})
        
        sut.startResume()
        
        XCTAssertEqual(timedStepModel.state.timerStatus, TimerStatus.stopped)
    }
    
    func testKeepsRunningWhenCallingStartResumeTwice() {
        timedStepModel = TimedStepModel(timedStepDefinition: timedStepData)
        timedStepModel.state.prepTimeRemainingInSeconds = 5
        timedStepModel.state.exerciseTimeRemainingInSeconds = 10
        timedStepModel.state.timerStatus = .stopped
        
        sut = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimer, onCompletion: {}, onStart: {})
        
        sut.startResume()
        sut.startResume()
        
        XCTAssertEqual(timedStepModel.state.timerStatus, TimerStatus.running)
    }

    func testKeepsPausedWhenCallingPauseTwice() {
        timedStepModel = TimedStepModel(timedStepDefinition: timedStepData)
        timedStepModel.state.prepTimeRemainingInSeconds = 5
        timedStepModel.state.exerciseTimeRemainingInSeconds = 20
        timedStepModel.state.timerStatus = .running
        
        sut = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimer, onCompletion: {}, onStart: {})
        
        sut.pause()
        sut.pause()
        
        XCTAssertEqual(timedStepModel.state.timerStatus, TimerStatus.stopped)
    }
    
    func testDecreasesOnlyExerciseTimeEachTick() {
        timedStepModel = TimedStepModel(timedStepDefinition: timedStepData)
        timedStepModel.state.prepTimeRemainingInSeconds = 0
        let exerciseTimeRemaingBeforeTick = 10.9
        let exerciseTimeRemainingAfterTick = exerciseTimeRemaingBeforeTick - timedStepModel.definition.delta
        timedStepModel.state.exerciseTimeRemainingInSeconds = exerciseTimeRemaingBeforeTick
        timedStepModel.state.timerStatus = .running
        
        sut = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimer, onCompletion: {}, onStart: {})
        
        periodicTimer.onTick()
        
        XCTAssertEqual(timedStepModel.state.exerciseTimeRemainingInSeconds, exerciseTimeRemainingAfterTick)
        XCTAssertEqual(timedStepModel.state.prepTimeRemainingInSeconds, 0)
    }
    
    func testDecreasesOnlyPrepTimeEachTick() {
        timedStepModel = TimedStepModel(timedStepDefinition: timedStepData)
        let prepTimeRemainingBeforeTick = 5.7
        let prepTimeRemainingAfterTick = prepTimeRemainingBeforeTick - timedStepModel.definition.delta
        timedStepModel.state.prepTimeRemainingInSeconds = prepTimeRemainingBeforeTick
        let exerciseTimeRemaingBeforeTick = 10.9
        timedStepModel.state.exerciseTimeRemainingInSeconds = exerciseTimeRemaingBeforeTick
        timedStepModel.state.timerStatus = .running
        
        sut = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimer, onCompletion: {}, onStart: {})
        
        periodicTimer.onTick()
        
        XCTAssertEqual(timedStepModel.state.prepTimeRemainingInSeconds, prepTimeRemainingAfterTick)
        XCTAssertEqual(timedStepModel.state.exerciseTimeRemainingInSeconds, exerciseTimeRemaingBeforeTick)
    }
        
    func testNothingChangesAfterReachingZeroWithOneCallbackCall() {
        timedStepModel = TimedStepModel(timedStepDefinition: timedStepData)
        timedStepModel.state.prepTimeRemainingInSeconds = 0.0
        timedStepModel.state.exerciseTimeRemainingInSeconds = timedStepModel.definition.delta
        timedStepModel.state.timerStatus = .running
        
        sut = TimerController(timedStepModel: timedStepModel, periodicTimer: periodicTimer, onCompletion: {}, onStart: {})
        
        periodicTimer.onTick()
        periodicTimer.onTick()

        XCTAssertEqual(timedStepModel.state.prepTimeRemainingInSeconds, 0.0)
        XCTAssertEqual(timedStepModel.state.exerciseTimeRemainingInSeconds, 0.0)
        XCTAssertEqual(timedStepModel.state.timerStatus, TimerStatus.stopped)
        
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
