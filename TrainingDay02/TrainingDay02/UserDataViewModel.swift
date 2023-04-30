
//  UserDataViewModel.swift
//  TrainingDay02
//
//  Created by William Hayden on 4/25/23.


import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UserDataViewModel: ObservableObject, Identifiable {
    
    @Published var userData: UserData
    var isDefaultData: Bool {
        return userData.name.isEmpty && userData.weight == 0 && userData.gender == Gender.other.rawValue && userData.squatMax == 0 && userData.benchMax == 0 && userData.deadliftMax == 0 && userData.weightUnit == WeightUnit.pounds.rawValue
    }
    @Published var weightUnit: WeightUnit {
        didSet {
            updateMaxesAndWeight()
        }
    }
    
    init(userData: UserData = UserData(email: "", name: "", weight: 0, gender: Gender.other.rawValue, squatMax: 0, benchMax: 0, deadliftMax: 0, weightUnit: WeightUnit.pounds.rawValue, dots: 0)) {
        self.userData = userData
        self.weightUnit = WeightUnit(rawValue: userData.weightUnit) ?? .pounds
    }
    
    func updateUserData(
        name: String,
        weightUnit: WeightUnit,
        gender: Gender,
        weight: String,
        squatMax: String,
        benchMax: String,
        deadliftMax: String
    ) {
        if weightUnit.rawValue != userData.weightUnit {
            let conversionFactor = weightUnit == .pounds ? 2.20462 : 0.453592
            userData.squatMax *= conversionFactor
            userData.benchMax *= conversionFactor
            userData.deadliftMax *= conversionFactor
            userData.weight *= conversionFactor
            userData.weightUnit = weightUnit.rawValue
        }
        
        userData.name = name.isEmpty ? userData.name : name
        userData.gender = gender.rawValue
        userData.weight = Double(weight) ?? userData.weight
        userData.squatMax = Double(squatMax) ?? userData.squatMax
        userData.benchMax = Double(benchMax) ?? userData.benchMax
        userData.deadliftMax = Double(deadliftMax) ?? userData.deadliftMax
        
        // Save updated user data to Firestore
        Task {
            _ = await saveUserData(userData: userData)
        }
    }
    func handleWeightUnitChange(newWeightUnit: WeightUnit) {
        if newWeightUnit.rawValue != userData.weightUnit {
            let conversionFactor = newWeightUnit == .pounds ? 2.20462 : 0.453592
            userData.squatMax *= conversionFactor
            userData.benchMax *= conversionFactor
            userData.deadliftMax *= conversionFactor
            userData.weight *= conversionFactor
            userData.weightUnit = newWeightUnit.rawValue
        }
    }
    
    private func updateMaxesAndWeight() {
        userData.squatMax = convertWeight(value: userData.squatMax, toUnit: weightUnit)
        userData.benchMax = convertWeight(value: userData.benchMax, toUnit: weightUnit)
        userData.deadliftMax = convertWeight(value: userData.deadliftMax, toUnit: weightUnit)
        userData.weight = convertWeight(value: userData.weight, toUnit: weightUnit)
    }
    
    func convertWeight(value: Double, toUnit targetUnit: WeightUnit) -> Double {
        let currentUnit = WeightUnit(rawValue: userData.weightUnit) ?? .pounds
        
        if currentUnit == targetUnit {
            return value
        } else if targetUnit == .pounds {
            let pounds = value * 2.20462
            return (pounds * 10).rounded() / 10
        } else {
            let kilograms = value / 2.20462
            return (kilograms * 10).rounded() / 10
        }
    }
    
    
    func calculateDots(total: Double, bodyweight: Double, gender: String) -> Double {
        let a, b, c, d, e: Double
        
        if gender == "male" {
            a = 0.000001093
            b = 0.0007391293
            c = 0.1918759221
            d = 24.0900756
            e = 307.75076
        } else {
            a = -0.0000010706
            b = 0.0005158568
            c = -0.1126655495
            d = 13.6175032
            e = -57.96288
        }
        
        let x = bodyweight
        let dots = (total + (a * pow(x, 4) + b * pow(x, 3) + c * pow(x, 2) + d * x + e)) * 500
        return dots
    }
    
    func updateDOTS() {
        func updateDOTS(weightUnit: WeightUnit) {
            let squatMaxKg = convertWeight(value: userData.squatMax, toUnit: .kilograms)
            let benchMaxKg = convertWeight(value: userData.benchMax, toUnit: .kilograms)
            let deadliftMaxKg = convertWeight(value: userData.deadliftMax, toUnit: .kilograms)
            
            let totalKg = squatMaxKg + benchMaxKg + deadliftMaxKg
            let bodyweightKg = convertWeight(value: userData.weight, toUnit: .kilograms)
            
            userData.dots = calculateDots(total: totalKg, bodyweight: bodyweightKg, gender: userData.gender)
        }
    }
    
    
    func loadUserData(email: String? = nil) async -> Bool {
        let db = Firestore.firestore()

        guard let userEmail = email ?? userData.email else { return false }

        do {
            let document = try await db.collection("userData").document(userEmail).getDocument()
            print("Document data: \(String(describing: document.data()))")
            
            if document.exists {
                do {
                    let loadedUserData = try document.data(as: UserData.self)
                    self.userData = loadedUserData
                    return true
                } catch {
                    print("Error decoding user data: \(error)")
                    return false
                }
            } else {
                print("Document not found")
                return false
            }
        } catch {
            print("Error loading user data: \(error.localizedDescription)")
            return false
        }
    }





    func saveUserData(userData: UserData) async -> String? {
        let db = Firestore.firestore()
        
        if userData.email != nil {
            do {
                try await db.collection("userData").document(Auth.auth().currentUser?.email ?? "").setData(userData.dictionary)
                print("Success in saving data for user \(userData.name)")
                updateDOTS()
                return userData.email
            } catch {
                print("Error could not update data in 'userData'")
                return nil
            }
        } else {
            do {
                _ = try await db.collection("userData").addDocument(data: userData.dictionary)
                self.userData = userData
                self.userData.email = Auth.auth().currentUser?.email ?? ""
                print("Success in saving new data")
                updateDOTS()
                return userData.id
                
            } catch {
                print("Error could not create a new instance of UserData")
                return nil
            }
        }
    }
}

