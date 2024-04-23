import SwiftUI

@main
struct TrainingApp: App {
    private var routineModel: RoutineModel
    private var routineController: RoutineCtrl
    private var appLifecycleModel: AppLifecycleModel
    private var appLifecycleController: AppLifecycleController
    private let soundPlayer: SoundPlyr

    init() {
        let appLifecycleModel = AppLifecycleModel()
        self.appLifecycleModel = appLifecycleModel
        let appLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
        self.appLifecycleController = appLifecycleController
        let workoutRoutine = "workoutRoutine.json"
//        let workoutRoutine = "workoutRoutine_real.json"
//        let workoutRoutine = "workoutRoutine_flo.json"
        let jsonRoutine: JsonRoutine = JsonRoutine.load(workoutRoutine)
        let routineSteps = RoutineSteps(jsonRoutine: jsonRoutine)
        let routineModel = RoutineModel(routineSteps: routineSteps)
        self.routineModel = routineModel
        let soundPlayer = SoundPlayer()
        self.soundPlayer = soundPlayer
        self.routineController = RoutineController(routineModel: routineModel, appLifecycleController: appLifecycleController, periodicTimerBuilder: { PeriodicTimerWrapper() }, soundPlayer: soundPlayer)
    }

    var body: some Scene {
        WindowGroup {
            TrainingLifecycleView(routineModel: routineModel, routineController: routineController, appLifecycleStatus: appLifecycleModel.appLifecycleStatus, appLifecycleController: appLifecycleController)
        }
    }
}

