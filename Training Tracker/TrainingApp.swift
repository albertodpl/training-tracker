import SwiftUI

@main
struct TrainingApp: App {
    @State private var modelData = ModelData()
    @State private var timerModel = TimerModel(timerStatus: .stopped, prepTimeInSeconds: 0, prepTimeRemainingInSeconds: 0, exerciseTimeInSeconds: 0, exerciseTimeRemainingInSeconds: 0)

    var body: some Scene {
        WindowGroup {
            TrainingView(modelData: $modelData, timerModel: $timerModel)
        }
    }
}

