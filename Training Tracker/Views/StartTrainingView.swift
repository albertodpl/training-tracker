import SwiftUI

struct StartTrainingView: View {
    var appLifecycleController: AppLifecycleController

    var body: some View {
        VStack {
            Spacer()
            TrainingButtonView(text: "Start", systemImage: "play.fill", click: appLifecycleController.startTraining)
        }
    }
}

#Preview {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel()
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    return StartTrainingView(appLifecycleController: appLifecycleController)
}
