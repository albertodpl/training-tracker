import SwiftUI

struct TimerView: View {
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: 24)
            .overlay {
                VStack {
                    Text("German hang")
                        .font(.title)
                    Text("w/ supinated grip (rings)")
                }
                .accessibilityElement(children: .combine)
                .foregroundStyle(Color.red)
            }
            .padding(.horizontal)
    }
}

#Preview {
    TimerView()
}
