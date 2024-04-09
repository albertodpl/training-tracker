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
        let modelData = ModelData(workoutRoutine: "workoutRoutine.json", appLifecycleController: appLifecycleController)
//        let modelData = ModelData(workoutRoutine: "workoutRoutine_real.json", appLifecycleController: appLifecycleController)
        self.modelData = modelData
        let timerModel = TimerModel(timerStatus: .stopped, prepTimeInSeconds: 0, prepTimeRemainingInSeconds: 0, exerciseTimeInSeconds: 0, exerciseTimeRemainingInSeconds: 0)
        timerModel.updateStep(currentStep: modelData.currentStep)
        self.timerModel = timerModel
    }

    var body: some Scene {
        WindowGroup {
            TrainingLifecycleView(modelData: $modelData, timerModel: $timerModel, appLifecycleStatus: appLifecycleModel.appLifecycleStatus, appLifecycleController: appLifecycleController)
        }
    }
}

