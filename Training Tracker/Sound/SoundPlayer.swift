import Foundation
import AudioToolbox

protocol SoundPlyr {
    func startExercise()
    func endExercise()
    func endPause()
}

class SoundPlayer: SoundPlyr {
    func startExercise() {
        AudioServicesPlaySystemSound(1009)
    }
    
    func endExercise() {
        AudioServicesPlaySystemSound(1009)
    }
    
    func endPause() {
        AudioServicesPlaySystemSound(1009)
    }
}
