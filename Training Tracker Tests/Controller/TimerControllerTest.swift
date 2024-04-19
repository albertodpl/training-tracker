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
    
    private func keepsRunningWhenCallingStartResumeTwice(_ step: Step) {
        timerModel = TimerModel(step: step)
        timerModel.prepTimeRemainingInSeconds = 5
        timerModel.exerciseTimeRemainingInSeconds = 10
        timerModel.timerStatus = .stopped
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.startResume()
        sut.startResume()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.running)
    }

    func testKeepsRunningWhenCallingStartResumeTwiceForTimedExerciseStep() {
        keepsRunningWhenCallingStartResumeTwice(timedExerciseStep)
    }

    func testKeepsRunningWhenCallingStartResumeTwiceForTimedRestStep() {
        keepsRunningWhenCallingStartResumeTwice(restStep)
    }

    private func keepsPausedWhenCallingPauseTwice(_ step: Step) {
        timerModel = TimerModel(step: step)
        timerModel.prepTimeRemainingInSeconds = 5
        timerModel.exerciseTimeRemainingInSeconds = 20
        timerModel.timerStatus = .running
        
        sut = TimerController(timerModel: timerModel, periodicTimer: periodicTimer, onCompletion: {})
        
        sut.pause()
        sut.pause()
        
        XCTAssertEqual(timerModel.timerStatus, TimerStatus.stopped)
    }

    func testKeepsPausedWhenCallingPauseTwiceForTimedExerciseStep() {
        keepsPausedWhenCallingPauseTwice(timedExerciseStep)
    }

    func testKeepsPausedWhenCallingPauseTwiceForTimedRestStep() {
        keepsPausedWhenCallingPauseTwice(restStep)
    }
    
    private func decreasesOnlyExerciseTimeEachTick(_ step: Step) {
        timerModel = TimerModel(step: step)
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
    
    func testDecreasesOnlyExerciseTimeEachTickForTimedExerciseStep() {
        decreasesOnlyExerciseTimeEachTick(timedExerciseStep)
    }

    func testDecreasesOnlyExerciseTimeEachTickForRestStep() {
        decreasesOnlyExerciseTimeEachTick(restStep)
    }

    private func decreasesOnlyPrepTimeEachTick(_ step: Step) {
        timerModel = TimerModel(step: step)
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
    
    func testDecreasesOnlyPrepTimeEachTickForTimedExerciseStep() {
        decreasesOnlyPrepTimeEachTick(timedExerciseStep)
    }

    func testDecreasesOnlyPrepTimeEachTickForRestStep() {
        decreasesOnlyPrepTimeEachTick(restStep)
    }
    
    private func nothingChangesAfterReachingZeroWithOneCallbackCall(_ step: Step) {
        timerModel = TimerModel(step: step)
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
    
    func testNothingChangesAfterReachingZeroWithOneCallbackCallForTimedExerciseStep() {
        nothingChangesAfterReachingZeroWithOneCallbackCall(timedExerciseStep)
    }
    
    func testNothingChangesAfterReachingWithOneCallbackCallZeroForRestStep() {
        nothingChangesAfterReachingZeroWithOneCallbackCall(restStep)
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
