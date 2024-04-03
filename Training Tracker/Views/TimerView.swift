import SwiftUI

struct TimerView: View {
    @Binding var timerModel: TimerModel
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.blue)
                Circle()
                    .trim(from: CGFloat(timerModel.exerciseTimeRemainingInSeconds / (timerModel.prepTimeInSeconds + timerModel.exerciseTimeInSeconds)), to: CGFloat((timerModel.prepTimeRemainingInSeconds + timerModel.exerciseTimeRemainingInSeconds) / (timerModel.prepTimeInSeconds + timerModel.exerciseTimeInSeconds)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundColor(.orange)
                Circle()
                    .trim(from: 0, to: CGFloat(timerModel.exerciseTimeRemainingInSeconds / (timerModel.prepTimeInSeconds + timerModel.exerciseTimeInSeconds)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundColor((timerModel.stepType == .rest) ? .green : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Text(formattedTime())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor((timerModel.prepTimeRemainingInSeconds > 0) ? .orange : ((timerModel.stepType == .rest) ? .green : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/))
            }
            .frame(maxWidth: 500)
        }
        .padding()
        .padding(.horizontal, 30)
        .opacity((timerModel.stepType == .repExercise) ? 0.3 : 1)
    }
    
    private func formattedTime() -> String {
        let secondsRemaining = Int((timerModel.prepTimeRemainingInSeconds > 0) ? timerModel.prepTimeRemainingInSeconds : timerModel.exerciseTimeRemainingInSeconds)
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    @State var timerModel = TimerModel(timerStatus: .stopped, prepTimeInSeconds: 20, prepTimeRemainingInSeconds: 10, exerciseTimeInSeconds: 75, exerciseTimeRemainingInSeconds: 75)
    return TimerView(timerModel: $timerModel)
}
