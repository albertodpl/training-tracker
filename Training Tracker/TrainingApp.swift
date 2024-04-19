import SwiftUI

@main
struct TrainingApp: App {
    private var routineModel: RoutineModel
    private var routineController: RoutineCtrl
    private var appLifecycleModel: AppLifecycleModel
    private var appLifecycleController: AppLifecycleController

    init() {
        let appLifecycleModel = AppLifecycleModel()
        self.appLifecycleModel = appLifecycleModel
        let appLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
        self.appLifecycleController = appLifecycleController
        let workoutRoutine = "workoutRoutine.json"
//        let workoutRoutine = "workoutRoutine_real.json"
        let jsonRoutine: JsonRoutine = JsonRoutine.load(workoutRoutine)
        let routineSteps = RoutineSteps(jsonRoutine: jsonRoutine)
        let routineModel = RoutineModel(routineSteps: routineSteps)
        self.routineModel = routineModel
        self.routineController = RoutineController(routineModel: routineModel, appLifecycleController: appLifecycleController, periodicTimerBuilder: { PeriodicTimerWrapper() })
    }

    var body: some Scene {
        WindowGroup {
            TrainingLifecycleView(routineModel: routineModel, routineController: routineController, appLifecycleStatus: appLifecycleModel.appLifecycleStatus, appLifecycleController: appLifecycleController)
        }
    }
}

