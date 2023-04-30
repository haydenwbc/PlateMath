//
//  PlateMathView.swift
//  TrainingDay02
//
//  Created by William Hayden on 4/26/23.
//

import SwiftUI

struct PlateMathView: View {
    
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.black], for: .disabled)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @State private var userWeight: String = ""
    @State private var weightUnit: WeightUnit = .pounds
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                userInputFields()
                Spacer()
                
                if let weight = Double(userWeight), (weightUnit == .pounds && weight >= 45) || (weightUnit == .kilograms && weight >= 20) {
                    BarbellView(weight: weight, weightUnit: weightUnit)
                        .frame(maxWidth: 300, maxHeight: 250)
                        .padding(.bottom)
                }
                Spacer()
                messageView()
            }
            .onChange(of: weightUnit) { _ in
                userWeight = ""
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
    private func userInputFields() -> some View {
            VStack(alignment: .center) {
                TextField("enter weight", text: $userWeight)
                    .padding()
                    .keyboardType(.decimalPad)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .background(Color.white.cornerRadius(90))
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                    .overlay {
                        Capsule()
                            .stroke(weightUnit == .pounds ? Color.blue : Color.red, lineWidth: 5)
                            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 0)
                    }
                Picker("Unit", selection: $weightUnit) {
                    ForEach(WeightUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue.lowercased())
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
        }
    private func messageView() -> some View {
        if let weight = Double(userWeight), (weightUnit == .pounds && weight >= 45) || (weightUnit == .kilograms && weight >= 20) {
            let convertedWeight = weightUnit == .pounds ? weight / 2.20462 : weight * 2.20462
            return AnyView(VStack {
                Text(String(format: "%.0f %@ = %.1f %@", weight, weightUnit.rawValue, convertedWeight, weightUnit == .pounds ? WeightUnit.kilograms.rawValue.lowercased() : WeightUnit.pounds.rawValue.lowercased()))
                    .foregroundColor(.white)
                    .font(Font.custom("Helvetica Neue", size: 20))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 90)
                            .fill(weightUnit == .pounds ? Color.blue : Color.red)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    )
            }
            .frame(width: 300, height: 60))
        } else {
            let message = weightUnit == .kilograms ? "enter a weight of at least 20 kg to view barbell" : "enter a weight of at least 45 lbs to view barbell"
            let color = weightUnit == .kilograms ? Color.red : Color.blue

            return AnyView(ZStack {
                Text(message)
                    .foregroundColor(.white)
                    .font(Font.custom("Helvetica Neue", size: 20))
                    .padding()
                    .bold()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .background(
                        RoundedRectangle(cornerRadius: 90)
                            .fill(color)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    )
            }
            .frame(width: 300, height: 60))
        }
    }
    }
    
    struct PlateMathView_Previews: PreviewProvider {
        static var previews: some View {
            PlateMathView()
        }
    }
