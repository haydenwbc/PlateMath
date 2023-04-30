//
//  UserData.swift
//  TrainingDay02
//
//  Created by William Hayden on 4/25/23.
//

import Foundation
import FirebaseFirestoreSwift

enum WeightUnit: String, Codable, CaseIterable {
    case pounds = "Pounds"
    case kilograms = "Kilograms"
}

enum Gender: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}


struct UserData: Identifiable, Codable {

    @DocumentID var id: String?
    var email: String?
    var name: String
    var weight: Double
    var gender: Gender.RawValue
    var squatMax: Double
    var benchMax: Double
    var deadliftMax: Double
    var weightUnit: WeightUnit.RawValue
    var dots: Double = 0

    
    var dictionary: [String: Any] {
        return ["email": email ?? "", "name": name, "weight": weight, "gender": gender, "squatMax": squatMax, "benchMax": benchMax, "deadliftMax": deadliftMax, "weightUnit": weightUnit, "dots": dots]
    }
}
