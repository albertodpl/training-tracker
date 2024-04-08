import SwiftUI

struct StartButtonView: View {
    var appLifecycleControler: AppLifecycleController

    var body: some View {
        Button {
            appLifecycleControler.startTraining()
        } label: {
            Label("Start", systemImage: "play.fill")
                .labelStyle(.titleAndIcon)
                .font(.largeTitle)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical)
        }
        .buttonStyle(.borderedProminent)
        .scaledToFit()
        .padding()
    }
}

#Preview {
    let appLifecycleModel: AppLifecycleModel = AppLifecycleModel()
    let appLifecycleController: AppLifecycleController = AppLifecycleController(appLifecycleModel: appLifecycleModel)
    return StartButtonView(appLifecycleControler: appLifecycleController)
}
