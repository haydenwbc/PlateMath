//
//  RPECalcView.swift
//  TrainingDay02
//
//  Created by William Hayden on 4/27/23.
//

import SwiftUI

struct RPECalcView: View {
    
    enum Lift: String, CaseIterable {
        case squat, bench, deadlift
    }
    
    @StateObject var userDataVM: UserDataViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedLift: Lift = .squat
    @State private var reps = 1
    @State private var rpe = 6.0
    @State private var weightUnit: WeightUnit = .pounds
    
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Picker("unit", selection: $weightUnit) {
                            ForEach(WeightUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue.lowercased())
                            }
                        }
                        .pickerStyle(.segmented)
                        Spacer()
                    }
                    .padding()
                    HStack {
                        Spacer()
                        Picker("lift", selection: $selectedLift) {
                            ForEach(Lift.allCases, id: \.self) { lift in
                                Text(lift.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        Spacer()
                    }
                    .padding()
                    HStack {
                        Group {
                            Text("select RPE:                  ")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.trailing)
                            Spacer()
                            Spacer()
                            Picker("RPE", selection: $rpe) {
                                ForEach(Array(stride(from: 6.0, through: 10.0, by: 0.5)), id: \.self) { rpeValue in
                                    Text("\(rpeValue, specifier: "%.1f")")
                                }
                            }
                            .padding(.leading)
                            .scaleEffect(1.5)
                            .tint(.black)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.red.cornerRadius(90))
                    .overlay {
                        Capsule()
                            .stroke(Color.red, lineWidth: 5)
                    }
                    .padding()
                    
                    HStack {
                        Spacer()
                        Spacer()
                        Stepper("    reps: \(reps)", value: $reps, in: 1...12)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(weightUnit == .pounds ? Color.blue.cornerRadius(90) : Color.red.cornerRadius(90))
                            .overlay {
                                Capsule()
                                    .stroke(weightUnit == .pounds ? Color.blue : Color.red, lineWidth: 5)
                            }
                        Spacer()
                        Spacer()
                    }
                    
                    
                    
                }
                
                
                
                let maxLift = getMaxLift(for: selectedLift)
                let weightToLoad = calculateWeightToLoad(maxLift: maxLift, reps: reps, rpe: rpe)
                HStack {
                    Spacer()
                    VStack {
                        
                        Text("weight loaded:")
                            .font(.custom("Helvetica Neue", size: 18).bold())
                            .foregroundColor(.red)
                        
                        Text("\((Int(weightToLoad) + 2) / 5 * 5)")
                            .font(.custom("Helvetica Neue", size: 50).bold().italic())
                            .foregroundColor(.black)
                    }
                    .padding()
                    Spacer()
                }
                .background(Color.white.cornerRadius(70))
                .padding()
                
                
                BarbellView(weight: weightToLoad, weightUnit: weightUnit)
                    .padding()
                
                Spacer()
            }
            .navigationBarTitle("")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    
                    Image(systemName: "chevron")
                    Button("back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundColor(.black)
                    .font(Font.custom("Helvetica Neue", size: 15))
                    .padding(.trailing)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        Text("Plate").foregroundColor(.white) +
                        Text("Math").foregroundColor(.red)
                    }
                    .font(Font.custom("Helvetica Neue", size: 20))
                    .bold()
                    .padding(.trailing)
                }
            }
            .navigationBarBackButtonHidden(true)
            
            .background(Color.gray)
        }
    }
    func getMaxLift(for lift: Lift) -> Double {
        switch lift {
        case .squat:
            return userDataVM.userData.squatMax
        case .bench:
            return userDataVM.userData.benchMax
        case .deadlift:
            return userDataVM.userData.deadliftMax
        }
    }
    func calculateWeightToLoad(maxLift: Double, reps: Int, rpe: Double) -> Double {
        let rpeChart = [
            6: [86.3, 83.7, 81.1, 78.6, 76.2, 73.9, 70.7, 68, 65.3, 62.6, 59.9, 57.2],
            6.5: [87.8, 85, 82.4, 79.9, 77.4, 75.1, 72.3, 69.4, 66.7, 64, 61.3, 58.6],
            7: [89.2, 86.3, 83.7, 81.1, 78.6, 76.2, 73.9, 70.7, 68, 65.3, 62.6, 59.9],
            7.5: [90.7, 87.8, 85, 82.4, 79.9, 77.4, 75.1, 72.3, 69.4, 66.7, 64, 61.3],
            8: [92.2, 89.2, 86.3, 83.7, 81.1, 78.6, 76.2, 73.9, 70.7, 68, 65.3, 62.6],
            8.5: [93.9, 90.7, 87.8, 85, 82.4, 79.9, 77.4, 75.1, 72.3, 69.4, 66.7, 64],
            9: [95.5, 92.2, 89.2, 86.3, 83.7, 81.1, 78.6, 76.2, 73.9, 70.7, 68, 65.3],
            9.5: [97.8, 93.9, 90.7, 87.8, 85, 82.4, 79.9, 77.4, 75.1, 72.3, 69.4, 66.7],
            10: [100, 95.5, 92.2, 89.2, 86.3, 83.7, 81.1, 78.6, 76.2, 73.9, 70.7, 68]
        ]
        
        if let percentages = rpeChart[Double(rpe)], reps - 1 < percentages.count {
            let percentage = percentages[reps - 1]
            var weightToLoad = maxLift * (percentage / 100.0)

            if userDataVM.userData.weightUnit == WeightUnit.pounds.rawValue && weightUnit == .kilograms {
                weightToLoad *= 0.45359237
            } else if userDataVM.userData.weightUnit == WeightUnit.kilograms.rawValue && weightUnit == .pounds {
                weightToLoad *= 2.20462262
            }

            return weightToLoad
        }
        
        return 0
    }
    
}

struct RPECalcView_Previews: PreviewProvider {
    static var previews: some View {
        RPECalcView(userDataVM: UserDataViewModel(userData: UserData(email: "haydenw@bc.edu", name: "Will", weight: 215, gender: Gender.male.rawValue, squatMax: 462.9, benchMax: 318.1, deadliftMax: 529.7, weightUnit: WeightUnit.pounds.rawValue)))
    }
}
