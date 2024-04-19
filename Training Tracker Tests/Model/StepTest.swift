import XCTest

@testable import Training_Tracker

final class StepTest: XCTestCase {
    let stepWithEverything = Step(
        name: "Step with everything name",
        description: "Step with everything description",
        repetitions: 3,
        prepTime: 8,
        duration: 20,
        stepType: StepType.reps
    )
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBuildStepWithName() {
        let name = "New name"
        let sut = stepWithEverything.withName(name)
        
        assertSameName(sut, name)
    }
    
    func testBuildStepWithDespcription() {
        let description = "New description"
        let sut = stepWithEverything.withDescription(description)
        
        assertSameDescription(sut, description)
    }

    func testBuildStepWithEmptyDespcription() {
        let description = ""
        let sut = stepWithEverything.withDescription(description)
        
        assertSameDescription(sut, description)
    }

    func testBuildStepWithRepetitions() {
        let repetitions = 99
        let sut = stepWithEverything.withRepetitions(repetitions)
        
        assertSameRepetitions(sut, repetitions)
    }

    func testBuildStepWithPrepTime() {
        let prepTime = 99
        let sut = stepWithEverything.withPrepTime(prepTime)
        
        assertSamePrepTime(sut, prepTime)
    }

    func testBuildStepWithDuration() {
        let duration = 99
        let sut = stepWithEverything.withDuration(duration)
        
        assertSameDuration(sut, duration)
    }

    func testBuildStepWithStepType() {
        let stepType = StepType.timed(.rest)
        let sut = stepWithEverything.withStepType(stepType)
        
        assertSameStepType(sut, stepType)
    }
    
    private func assertSameName(_ step: Step, _ name: String) {
        XCTAssertEqual(step.name, name)
    }

    private func assertSameDescription(_ step: Step, _ description: String?) {
        XCTAssertEqual(step.description, description)
    }

    private func assertSameRepetitions(_ step: Step, _ repetitions: Int?) {
        XCTAssertEqual(step.repetitions, repetitions)
    }

    private func assertSamePrepTime(_ step: Step, _ prepTime: Int?) {
        XCTAssertEqual(step.prepTime, prepTime)
    }

    private func assertSameDuration(_ step: Step, _ duration: Int?) {
        XCTAssertEqual(step.duration, duration)
    }

    private func assertSameStepType(_ step: Step, _ stepType: StepType) {
        XCTAssertEqual(step.stepType, stepType)
    }
}
