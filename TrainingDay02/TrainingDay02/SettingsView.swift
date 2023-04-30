//
//  SettingsView.swift
//  TrainingDay02
//
//  Created by William Hayden on 4/28/23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var userDataVM: UserDataViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var weight = ""
    @State private var weightUnit: WeightUnit = .pounds
    @State private var gender: Gender = .male
    @State private var squatMax = ""
    @State private var benchMax = ""
    @State private var deadliftMax = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Info")) {
                    TextField("Name", text: $name)
                    Picker("Weight Unit", selection: $weightUnit) {
                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: weightUnit) { newWeightUnit in
                        userDataVM.handleWeightUnitChange(newWeightUnit: newWeightUnit)
                    }
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    TextField("Weight", text: $weight)
                }
                
                Section(header: Text("Lifts")) {
                    TextField("Max Squat", text: $squatMax)
                    TextField("Max Bench", text: $benchMax)
                    TextField("Max Deadlift", text: $deadliftMax)
                }
                
                Button("Submit") {
                    userDataVM.updateUserData(
                        name: name,
                        weightUnit: weightUnit,
                        gender: gender,
                        weight: weight,
                        squatMax: squatMax,
                        benchMax: benchMax,
                        deadliftMax: deadliftMax
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                loadData()
            }
        }
    }
    
    private func loadData() {
        name = userDataVM.userData.name
        weightUnit = WeightUnit(rawValue: userDataVM.userData.weightUnit) ?? .pounds
        gender = Gender(rawValue: userDataVM.userData.gender) ?? .male
        weight = String(userDataVM.userData.weight)
        squatMax = String(userDataVM.userData.squatMax)
        benchMax = String(userDataVM.userData.benchMax)
        deadliftMax = String(userDataVM.userData.deadliftMax)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userDataVM:(UserDataViewModel(userData: UserData(id: nil, email: "haydenw@bc.edu", name: "Will", weight: 215, gender: Gender.male.rawValue, squatMax: 462.9, benchMax: 318.1, deadliftMax: 529.7, weightUnit: WeightUnit.pounds.rawValue, dots: 0.0))))
    }
}

