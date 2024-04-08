import SwiftUI

struct TrainingButtonView: View {
    let label: String
    let systemImage: String
    let click: () -> ()
    
    init(text label: String, systemImage: String, click: @escaping () -> ()) {
        self.label = label
        self.systemImage = systemImage
        self.click = click
    }

    var body: some View {
        Button {
            click()
        } label: {
            Label(label, systemImage: systemImage)
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

#Preview ("Start") {
    return TrainingButtonView(text: "Start", systemImage: "play.fill", click: {})
}

#Preview ("Pause") {
    return TrainingButtonView(text: "Pause", systemImage: "pause.fill", click: {})
}

#Preview ("Complete") {
    return TrainingButtonView(text: "Complete", systemImage: "checkmark", click: {})
}
