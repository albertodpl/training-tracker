import SwiftUI

@main
struct TrainingApp: App {
    @State private var modelData: ModelData
    @State private var timerModel: TimerModel
    @State private var appLifecycleModel: AppLifecycleModel
    private var appLifecycleController: AppLifecycleController
    
    init() {
        let appLifecycleModel = AppLifecycleModel()
        self.appLifecycleModel = appLifecycleModel
        let appLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
        self.appLifecycleController = appLifecycleController
        self.modelData = ModelData(appLifecycleController: appLifecycleController)
        self.timerModel = TimerModel(timerStatus: .stopped, prepTimeInSeconds: 0, prepTimeRemainingInSeconds: 0, exerciseTimeInSeconds: 0, exerciseTimeRemainingInSeconds: 0)
    }

    var body: some Scene {
        WindowGroup {
            TrainingLifecycleView(modelData: $modelData, timerModel: $timerModel, appLifecycleStatus: appLifecycleModel.appLifecycleStatus, appLifecycleController: appLifecycleController)
        }
    }
}

