import SwiftUI

struct RepsView: View {
    var step: Step
    let repsFontSize = CGFloat(80)
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Text(formattedReps())
                    .font(.system(size: repsFontSize))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                
                Circle()
                    .stroke(lineWidth: 10)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
            .frame(maxWidth: 500)
        }
        .padding()
        .padding(.horizontal, 30)
    }
    
    private func formattedReps() -> String {
        return "x \(step.repsStepData?.repetitions ?? 0)"
    }
}

#Preview("Reps") {
    let step = Step(name: "Reps", repetitions: 8)
    return RepsView(step: step)
}

#Preview("Reps 2 digits") {
    let step = Step(name: "Reps", repetitions: 56)
    return RepsView(step: step)
}

#Preview("Reps 3 digits") {
    let step = Step(name: "Reps", repetitions: 56)
    return RepsView(step: step)
}

#Preview("No reps data") {
    let step = Step(name: "No reps data")
    return RepsView(step: step)
}
