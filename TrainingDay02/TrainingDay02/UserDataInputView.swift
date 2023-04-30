//
//  UserDataInputView.swift
//  TrainingDay02
//
//  Created by William Hayden on 4/26/23.
//

import SwiftUI

struct UserDataInputView: View {
    
    @EnvironmentObject var userDataVM : UserDataViewModel
    @State private var showHomePageView = false
    @State private var name = ""
    @State private var weight = ""
    @State private var gender = Gender.male
    @State private var squatMax = ""
    @State private var benchMax = ""
    @State private var deadliftMax = ""
    @State private var weightUnit = WeightUnit.pounds
    private var allFieldsFilled: Bool {
        !name.isEmpty && !weight.isEmpty && !squatMax.isEmpty && !benchMax.isEmpty && !deadliftMax.isEmpty
        
    }
    
    var body: some View {
        ZStack {
            Color.gray
                .edgesIgnoringSafeArea(.all)
            VStack {
                Capsule()
                    .fill(Color.white)
                    .frame(height: 100)
                    .overlay {
                        VStack {
                            Text("welcome to Plate").font(Font.custom("Helvetica Neue", size: 20))
                                .foregroundColor(.black)+Text("Math").font(Font.custom("Helvetica Neue", size: 20))
                                .foregroundColor(.red)+Text("!").font(Font.custom("Helvetica Neue", size: 20))
                                .foregroundColor(.black)
                            
                            
                            Text("before you can continue, please enter the following information:")
                                .font(Font.custom("Helvetica Neue", size: 14))
                                .foregroundColor(.red)
                                .italic()
                                .minimumScaleFactor(0.5)
                        }
                        
                    }
                
                Spacer()
                
                
                TextField("name", text: $name)
                    .padding()
                    .keyboardType(.alphabet)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .foregroundColor(.black)
                    .background(RoundedRectangle(cornerRadius: 90).fill(Color.white))
                    .textFieldStyle(.plain)
                    .overlay {
                        Capsule()
                            .stroke(weightUnit == .pounds ? Color.blue : Color.red, lineWidth: 5)
                            .shadow(color: weightUnit == .pounds ? Color.blue.opacity(0.5) : Color.red.opacity(0.5), radius: 3, x: 0, y: 0)
                    }
                
                
                Group {
                    HStack {
                        Text("I train on:")
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .foregroundColor(.white)
                            .font(.custom("HelveticaNeue", size: 18))
                        
                        Section(header: Text("")) {
                            Picker("", selection: $weightUnit) {
                                ForEach(WeightUnit.allCases, id: \.self) { unit in
                                    Text(unit.rawValue.lowercased()).tag(unit)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.trailing)
                        }
                    }
                    HStack {
                        Text("I identify as:")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .padding([.leading, .bottom])
                            .font(.custom("HelveticaNeue", size: 18))
                        GeometryReader { geometry in
                            Picker("", selection: $gender) {
                                ForEach(Gender.allCases, id: \.self) { unit in
                                    Text(unit.rawValue.lowercased()).tag(unit.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(height: geometry.size.height * 0.6)
                            .clipped()
                            .padding(.trailing)
                        }
                        .frame(height: 60)
                    }
                }
                Group {
                    Group {
                        TextField("weight", text: $weight)
                            .padding()
                            .keyboardType(.decimalPad)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .submitLabel(.next)
                            .background(Color.white.cornerRadius(90))
                            .foregroundColor(.black)
                        Spacer()
                        TextField("squat one rep max", text: $squatMax)
                            .padding()
                            .keyboardType(.decimalPad)
                            .submitLabel(.next)
                            .background(Color.white.cornerRadius(90))
                            .foregroundColor(.black)
                        Spacer()
                        TextField("bench press one rep max", text: $benchMax)
                            .padding()
                            .keyboardType(.decimalPad)
                            .submitLabel(.next)
                            .background(Color.white.cornerRadius(90))
                            .foregroundColor(.black)
                        Spacer()
                        TextField("deadlift one rep max", text: $deadliftMax)
                            .padding()
                            .keyboardType(.decimalPad)
                            .submitLabel(.next)
                            .background(Color.white.cornerRadius(90))
                            .foregroundColor(.black)
                    }
                    .textFieldStyle(.plain)
                    .overlay {
                        Capsule()
                            .stroke(weightUnit == .pounds ? Color.blue : Color.red, lineWidth: 5)
                            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 0)
                    }
                    Spacer()
                    Button("submit") {
                        if allFieldsFilled {
                            let newUserData = UserData(email: userDataVM.userData.email, name: name, weight: Double(weight) ?? 0, gender: gender.rawValue, squatMax: Double(squatMax) ?? 0, benchMax: Double(benchMax) ?? 0, deadliftMax: Double(deadliftMax) ?? 0, weightUnit: weightUnit.rawValue)
                            userDataVM.userData = newUserData
                            
                            Task {
                                _ = await userDataVM.saveUserData(userData: newUserData)
                                
                            }
                            showHomePageView = true
                        }
                    }
                    .tint(.red)
                    .disabled(!allFieldsFilled)
                    .buttonStyle(.borderedProminent)
                    .scaleEffect(1.6)
                    
                    
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $showHomePageView) {
            HomePageView(userDataVM: userDataVM)
        }
    }
}

struct UserDataInputView_Previews: PreviewProvider {
    static var previews: some View {
        UserDataInputView()
            .environmentObject(UserDataViewModel(userData: UserData(id: nil, email: "haydenw@bc.edu", name: "", weight: 0, gender: Gender.male.rawValue, squatMax: 0, benchMax: 0, deadliftMax: 0, weightUnit: WeightUnit.kilograms.rawValue)))
    }
}
