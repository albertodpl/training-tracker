import SwiftUI

struct TrainingLifecycleView: View {
    @Binding var modelData: ModelData
    @Binding var timerModel: TimerModel

    var appLifecycleStatus: AppLifecycleStatus
    var appLifecycleController: AppLifecycleController

    var body: some View {
        switch appLifecycleStatus {
        case .trainingNotStrated:
            StartTrainingView(appLifecycleController: appLifecycleController)
        case .trainingStarted:
            TrainingView(modelData: $modelData, timerModel: $timerModel)
        case .trainingCompleted:
            TrainingCompletedView()
        }
    }
}

#Preview {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel()
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    @State var modelData = ModelData(workoutRoutine: "workoutRoutine.json", appLifecycleController: appLifecycleController)
    @State var timerModel = TimerModel(timerStatus: .stopped, prepTimeInSeconds: 5, prepTimeRemainingInSeconds: 2, exerciseTimeInSeconds: 75, exerciseTimeRemainingInSeconds: 75)
    return TrainingLifecycleView(modelData: $modelData, timerModel: $timerModel, appLifecycleStatus: appLifecycleModel.appLifecycleStatus, appLifecycleController: appLifecycleController)
}
