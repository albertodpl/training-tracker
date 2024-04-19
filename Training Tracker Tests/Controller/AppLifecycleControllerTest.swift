import XCTest

@testable import Training_Tracker

final class AppLifecycleControllerTest: XCTestCase {
    func testTransitionFromNotStartedToStarted() {
        let appLifecycleModel = AppLifecycleModel(appLifecycleStatus: .trainingNotStrated)
        let sut = AppLifecycleController(appLifecycleModel: appLifecycleModel)

        sut.startTraining()

        XCTAssertEqual(appLifecycleModel.appLifecycleStatus, .trainingStarted)
    }

    func testTransitionFromStartedToCompleted() {
        let appLifecycleModel = AppLifecycleModel(appLifecycleStatus: .trainingStarted)
        let sut = AppLifecycleController(appLifecycleModel: appLifecycleModel)

        sut.completeTraining()

        XCTAssertEqual(appLifecycleModel.appLifecycleStatus, .trainingCompleted)
    }
}
