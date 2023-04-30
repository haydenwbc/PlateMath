//
//  ContentView.swift
//  TrainingDay02
//
//  Created by William Hayden on 4/25/23.
//

import SwiftUI
import FirebaseAuth

struct HomePageView: View {
    @StateObject var userDataVM: UserDataViewModel
    @Environment(\.presentationMode) private var presentationMode
    @State private var showSettings = false
    
    
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                Color.gray
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    
                    HStack(alignment: .top) {
                        
                        Text("  welcome back,")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .italic()
                            .scaleEffect(1.2)
                        
                        Text("     \(userDataVM.userData.name.capitalized)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .scaleEffect(1.2)
                        
                        
                    }
                    Spacer()
                    Group {
                        VStack {
                            Capsule()
                                .fill(Color.red)
                                .frame(height: 100)
                                .overlay(
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Text("squat max")
                                                .font(Font.custom("Helvetica Neue", size: 15))
                                                .italic()
                                                .foregroundColor(.black)
                                            Text("\(String(format: "%.1f", userDataVM.userData.squatMax))")
                                                .font(Font.custom("Helvetica Neue", size: 20))
                                                .bold()
                                                .foregroundColor(.white)
                                        }
                                        Spacer()
                                        VStack {
                                            Text("bench max")
                                                .font(Font.custom("Helvetica Neue", size: 15))
                                                .italic()
                                                .foregroundColor(.black)
                                            Text("\(String(format: "%.1f", userDataVM.userData.benchMax))")
                                                .font(Font.custom("Helvetica Neue", size: 20))
                                                .bold()
                                                .foregroundColor(.white)
                                        }
                                        Spacer()
                                        VStack {
                                            Text("deadlift max")
                                                .font(Font.custom("Helvetica Neue", size: 15))
                                                .italic()
                                                .foregroundColor(.black)
                                            Text("\(String(format: "%.1f", userDataVM.userData.deadliftMax))")
                                                .font(Font.custom("Helvetica Neue", size: 20))
                                                .bold()
                                                .foregroundColor(.white)
                                        }
                                        Spacer()
                                        
                                    }
                                )
                            Capsule()
                                .fill(Color.white)
                                .frame(width: 200, height: 75)
                                .overlay(
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Text("total")
                                                .font(Font.custom("Helvetica Neue", size: 20))
                                                .italic()
                                                .foregroundColor(.red)
                                            Text("\(String(format: "%.1f", userDataVM.userData.squatMax + userDataVM.userData.benchMax + userDataVM.userData.deadliftMax))")
                                                .font(Font.custom("Helvetica Neue", size: 25))
                                                .bold()
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                    }
                                )
                        }
                        
                        Spacer()
                        VStack {
                            HStack(alignment: .center) {
                                Spacer()
                                
                                NavigationLink {
                                    PlateMathView()
                                } label: {
                                    Text("barbell loader and pound / kilo converter")
                                        .foregroundColor(.white)
                                        .font(Font.custom("Helvetica Neue", size: 20))
                                        .padding()
                                        .bold()
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.red)
                                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                                        )
                                    
                                }
                                Spacer()
                            }

                            .padding(.leading)
                            HStack(alignment: .center) {
                                Spacer()
                                
                                NavigationLink {
                                    RPECalcView(userDataVM: userDataVM)
                                } label: {
                                    Text("RPE calculator and set generator")
                                        .foregroundColor(.white)
                                        .font(Font.custom("Helvetica Neue", size: 20))
                                        .padding()
                                        .bold()
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.red)
                                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                                        )
                                    
                                }
                                Spacer()
                            }
                            .padding(.leading)
                        }
                        Spacer()
                            .navigationTitle("")
                            .toolbar {
                                ToolbarItemGroup(placement: .navigationBarLeading) {
                                    HStack {
                                        Text("Plate").foregroundColor(.white) +
                                        Text("Math").foregroundColor(.red)
                                    }
                                    .font(Font.custom("Helvetica Neue", size: 25))
                                    .bold()
                                    .padding(.trailing)
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    NavigationLink {
                                        SettingsView(userDataVM: userDataVM)
                                    } label: {
                                        Image(systemName: "gear")
                                            .foregroundColor(.white)
                                            .scaleEffect(1.2)
                                    }
  
                                }
                                
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("sign out") {
                                        do {
                                            try Auth.auth().signOut()
                                            print("Log out successful")
                                            presentationMode.wrappedValue.dismiss()
                                        } catch {
                                            print("ERROR could not sign out")
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.white)
                                    .foregroundColor(.black)
                                    .font(Font.custom("Helvetica Neue", size: 17))
                                }
                                
                            }
                    }
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(userDataVM: UserDataViewModel(userData: UserData(id: nil, email: "haydenw@bc.edu", name: "Will", weight: 0, gender: Gender.male.rawValue, squatMax: 462.9, benchMax: 318.1, deadliftMax: 529.7, weightUnit: WeightUnit.pounds.rawValue, dots: 0.0)))
    }
}
