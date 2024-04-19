import SwiftUI

struct TrainingLifecycleView: View {
    var routineModel: RoutineModel
    var routineController: RoutineCtrl
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

#Preview("Start training") {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel(appLifecycleStatus: .trainingNotStrated)
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    let jsonRoutine: JsonRoutine = JsonRoutine.load("workoutRoutine.json")
    let routineSteps = RoutineSteps(jsonRoutine: jsonRoutine)
    let routineModel = RoutineModel(routineSteps: routineSteps)
    let periodicTimer = PeriodicTimerWrapper()
    let routineController = RoutineController(routineModel: routineModel, appLifecycleController: appLifecycleController, periodicTimerBuilder: { periodicTimer })
    return TrainingLifecycleView(routineModel: routineModel, routineController: routineController, appLifecycleStatus: appLifecycleModel.appLifecycleStatus, appLifecycleController: appLifecycleController)
}

#Preview("Training") {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel(appLifecycleStatus: .trainingStarted)
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    let jsonRoutine: JsonRoutine = JsonRoutine.load("workoutRoutine.json")
    let routineSteps = RoutineSteps(jsonRoutine: jsonRoutine)
    let routineModel = RoutineModel(routineSteps: routineSteps)
    let periodicTimer = PeriodicTimerWrapper()
    let routineController = RoutineController(routineModel: routineModel, appLifecycleController: appLifecycleController, periodicTimerBuilder: { periodicTimer })
    return TrainingLifecycleView(routineModel: routineModel, routineController: routineController, appLifecycleStatus: appLifecycleModel.appLifecycleStatus, appLifecycleController: appLifecycleController)
}

#Preview("Training completed") {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel(appLifecycleStatus: .trainingCompleted)
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    let jsonRoutine: JsonRoutine = JsonRoutine.load("workoutRoutine.json")
    let routineSteps = RoutineSteps(jsonRoutine: jsonRoutine)
    let routineModel = RoutineModel(routineSteps: routineSteps)
    let periodicTimer = PeriodicTimerWrapper()
    let routineController = RoutineController(routineModel: routineModel, appLifecycleController: appLifecycleController, periodicTimerBuilder: { periodicTimer })
    return TrainingLifecycleView(routineModel: routineModel, routineController: routineController, appLifecycleStatus: appLifecycleModel.appLifecycleStatus, appLifecycleController: appLifecycleController)
}
