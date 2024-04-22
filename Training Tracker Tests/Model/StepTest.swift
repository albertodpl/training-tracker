import XCTest

@testable import Training_Tracker

final class StepTest: XCTestCase {
    let stepWithEverything = Step(
        name: "Step with everything name",
        description: "Step with everything description",
        stepType: StepType.reps(RepsStepDefinition(repetitions: 3))
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
    
    func testBuildStepWithDescription() {
        let description = "New description"
        let sut = stepWithEverything.withDescription(description)
        
        assertSameDescription(sut, description)
    }

    func testBuildStepWithEmptyDespcription() {
        let description = ""
        let sut = stepWithEverything.withDescription(description)
        
        assertSameDescription(sut, description)
    }

    func testBuildStepWithStepTypeRest() {
        let stepType = StepType.timed(.rest(TimedStepDefinition(type: .rest, prepTime: 8, duration: 20)))
        let sut = stepWithEverything.withStepType(stepType)
        
        assertSameStepType(sut, stepType)
    }

    func testBuildStepWithStepTypeTimedExercise() {
        let stepType = StepType.timed(.exercise(TimedStepDefinition(type: .exercise, prepTime: 8, duration: 20)))
        let sut = stepWithEverything.withStepType(stepType)
        
        assertSameStepType(sut, stepType)
    }
    
    func testBuildStepWithStepTypeReps() {
        let stepType = StepType.reps(RepsStepDefinition(repetitions: 8))
        let sut = stepWithEverything.withStepType(stepType)
        
        assertSameStepType(sut, stepType)
    }
    
    private func assertSameName(_ step: Step, _ name: String) {
        XCTAssertEqual(step.name, name)
    }

    private func assertSameDescription(_ step: Step, _ description: String?) {
        XCTAssertEqual(step.description, description)
    }

    private func assertSameStepType(_ step: Step, _ stepType: StepType) {
        XCTAssertEqual(step.stepType, stepType)
    }
}
