//
//  LoginView.swift
//  TrainingDay02
//
//  Created by William Hayden on 4/25/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    enum Field {
        case email, password
    }
    @State private var userDataVM: UserDataViewModel?
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @FocusState private var focusField: Field?
    @State private var sheetIsPresented = false
    @State private var buttonsDisabled = true
    
    var body: some View {
        ZStack {
            Color.gray
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Spacer()
                HStack {
                    Text("Plate").foregroundColor(.white) +
                    Text("Math").foregroundColor(.red)
                }
                .font(.custom("orbitron", size: 50))
                
                
                Spacer()
                Spacer()
                Group {
                    TextField("Email", text: $email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .background(Color.white.cornerRadius(90))
                        .foregroundColor(.black)
                        .onSubmit {
                            focusField = .password
                        }
                        .onChange(of: email) { _ in
                            enableButtons()
                        }
                    
                    
                    
                    
                    SecureField("Password", text: $password)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .submitLabel(.done)
                        .background(Color.white.cornerRadius(90))
                        .foregroundColor(.black)
                        .onSubmit {
                            focusField = nil
                        }
                        .onChange(of: password) { _ in
                            enableButtons()
                        }
                }
                .textFieldStyle(.plain)
                .overlay {
                    Capsule()
                        .stroke(.red.opacity(1.0), lineWidth: 5)
                    
                }
                
                HStack {
                    Button {
                        register()
                    } label: {
                        Text("Sign-Up")
                            .font(Font.custom("helvetica-neue", size: 20))
                            .italic()
                    }
                    .tint(.red)
                    .controlSize(.large)
                    .foregroundColor(.white)
                    .padding(.trailing)
                    .buttonStyle(.borderedProminent)
                    
                    
                    Button {                        login()
                    } label: {
                        Text("Log In")
                    }
                    .font(Font.custom("helvetica-neue", size: 20))
                    .padding(.leading)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                }
                .disabled(buttonsDisabled)
                
                .padding()
                Spacer()
                
            }
            .padding()
            
        }

        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        
        .fullScreenCover(item: $userDataVM) { userDataVM in
            if userDataVM.isDefaultData {
                UserDataInputView()
                    .environmentObject(userDataVM)
            } else {
                HomePageView(userDataVM: userDataVM)
            }
        }
    }
    
    
    
    
    func enableButtons() {
        let emailIsGood = email.count > 6 && email.contains("@")
        let passwordIsGood = password.count > 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Signup Error: \(error.localizedDescription)")
                alertMessage = "SIGNUP ERROR \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Sign up success")

                let userDataVM = UserDataViewModel()
                userDataVM.userData.email = email


                Task {
                    let saveResult = await userDataVM.saveUserData(userData: userDataVM.userData)
                    if saveResult == nil {
                        self.userDataVM = userDataVM
                        sheetIsPresented = true
                        print("Setting sheetIsPresented to true in register function")
                    } else {
                        print("Error saving UserData for new user: \(saveResult!)")
                    }
                }
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Login success")

                let userDataVM = UserDataViewModel()

                Task {
                    let success = await userDataVM.loadUserData(email: email)
                    if success {
                        self.userDataVM = userDataVM
                        sheetIsPresented = true
                        print("Setting sheetIsPresented to true in login function")
                    } else {
                        print("User's UserData not found.")
                    }
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
