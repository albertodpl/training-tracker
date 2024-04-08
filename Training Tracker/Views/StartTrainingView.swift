import SwiftUI

struct StartTrainingView: View {
    var appLifecycleController: AppLifecycleController

    var body: some View {
        VStack {
            Spacer()
            StartButtonView(appLifecycleControler: appLifecycleController)
        }
    }
}

#Preview {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel()
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    return StartTrainingView(appLifecycleController: appLifecycleController)
}
