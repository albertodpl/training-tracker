import Foundation

enum AppLifecycleStatus {
    case trainingNotStrated
    case trainingStarted
    case trainingCompleted
}

@Observable
final class AppLifecycleModel {
    var appLifecycleStatus: AppLifecycleStatus
    
    init(appLifecycleStatus: AppLifecycleStatus = .trainingNotStrated) {
        self.appLifecycleStatus = appLifecycleStatus
    }
}

final class AppLifecycleController {
    var appLifecycleModel: AppLifecycleModel
    
    init(appLifecycleModel: AppLifecycleModel) {
        self.appLifecycleModel = appLifecycleModel
    }

    func startTraining() {
        if appLifecycleModel.appLifecycleStatus == .trainingNotStrated {
            appLifecycleModel.appLifecycleStatus = .trainingStarted
            print("startTraining(): transitioned to \(appLifecycleModel.appLifecycleStatus)")
        } else {
            // TODO: Handle impossible transition
            print("TODO: ERROR: Handle impossible transition to start training from \(appLifecycleModel.appLifecycleStatus).")
        }
    }
    
    func completeTraining() {
        if appLifecycleModel.appLifecycleStatus == .trainingStarted {
            appLifecycleModel.appLifecycleStatus = .trainingCompleted
            print("completeTraining(): transitioned to \(appLifecycleModel.appLifecycleStatus)")
        } else {
            // TODO: Handle impossible transition
            print("TODO: ERROR: Handle impossible transition to complete training from \(appLifecycleModel.appLifecycleStatus).")
        }
    }
}
