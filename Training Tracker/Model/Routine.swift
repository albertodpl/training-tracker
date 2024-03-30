import Foundation

// TODO: Populate with sensible values if they are not present and makes sense, e.g., prepTime = 0

struct Routine: Codable {
    var name: String
    var exerciseGroup: [ExerciseGroup]
}

struct ExerciseGroup: Codable {
    var name: String?
    var restInBetween: Int?
    var restAtTheEnd: Int?
    var exerciseGroup: [ExerciseGroup]?
    var exercise: [Exercise]?
}

struct Exercise: Codable {
    var name: String
    var description: String?
    var numberOfSets: Int
    var prepTime: [Int]?
    var duration: [Int]?
    var repetitions: [Int]?
    var tempo: Tempo?
}

struct Tempo: Codable {
    var eccentric: Int?
    var eccentricRest: Int?
    var concentric: Int?
    var concentricRest: Int?
}
