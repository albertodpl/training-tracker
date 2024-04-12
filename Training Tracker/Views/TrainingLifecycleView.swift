import SwiftUI

struct TrainingLifecycleView: View {
    var routineModel: RoutineModel
    var routineController: RoutineController
    var appLifecycleStatus: AppLifecycleStatus
    var appLifecycleController: AppLifecycleController

    var body: some View {
        switch appLifecycleStatus {
        case .trainingNotStrated:
            StartTrainingView(appLifecycleController: appLifecycleController)
        case .trainingStarted:
            TrainingView(routineModel: routineModel, routineController: routineController)
        case .trainingCompleted:
            TrainingCompletedView()
        }
    }
}

#Preview {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel()
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    let jsonRoutine: JsonRoutine = load("workoutRoutine.json")
    let routineSteps = RoutineSteps(jsonRoutine: jsonRoutine)
    let routineModel = RoutineModel(routineSteps: routineSteps)
    let routineController = RoutineController(routineModel: routineModel, appLifecycleController: appLifecycleController)
    return TrainingLifecycleView(routineModel: routineModel, routineController: routineController, appLifecycleStatus: appLifecycleModel.appLifecycleStatus, appLifecycleController: appLifecycleController)
}
