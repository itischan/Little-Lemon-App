//
//  Onboarding.swift
//  LittleLemon
//
//  Created by Chandru Kumaran on 11/28/23
//

import SwiftUI

var onboardingFirstName =  "onboardingFirstName"
var onboardingLastName =  "onboardingLastName"
var onboardingEmail =  "onboardingEmail"

class OnboardingViewModel: ObservableObject {
    // MARK: - References / Properties
    @Published public var isLoggedIn: Bool = false
}

struct Onboarding: View {
    // MARK: - References / Properties
    let persistanceController = PersistenceController.shared
    @StateObject private var onboardingViewModel: OnboardingViewModel = OnboardingViewModel()
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    private let normalFontSize = UIFont.systemFont(ofSize: 16)
    private let asteriskFontSize = UIFont.systemFont(ofSize: 12)
    @State private var invalidFirstName: Bool = false
    @State private var invalidLastName: Bool = false
    @State private var invalidEmail: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("First Name")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                    +
                    Text("*")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                        .baselineOffset((normalFontSize.capHeight - asteriskFontSize.capHeight))
                    HStack {
                        TextField("", text: $firstName)
                            .padding(.leading, 5)
                    }
                    .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                    .background(
                        Color.white
                    )
                    .border(invalidFirstName ? .red : .black, width: 0.5)
                }
                .padding(.top)
                VStack(alignment: .leading) {
                    Text("Last Name")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                    +
                    Text("*")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                        .baselineOffset((normalFontSize.capHeight - asteriskFontSize.capHeight))
                    HStack {
                        TextField("", text: $lastName)
                            .padding(.leading, 5)
                    }
                    .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                    .background(
                        Color.white
                    )
                    .border(invalidLastName ? .red : .black, width: 0.5)
                }
                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                    +
                    Text("*")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                        .baselineOffset((normalFontSize.capHeight - asteriskFontSize.capHeight))
                    HStack {
                        TextField("", text: $email)
                            .padding(.leading, 5)
                    }
                    .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                    .background(
                        Color.white
                    )
                    .border(invalidEmail ? .red : .black, width: 0.5)
                }
                Spacer()
                NavigationLink(value: "") {
                    Button {
                        self.checkForValidCredentials {
                            UserDefaults.standard.set(firstName, forKey: onboardingFirstName)
                            UserDefaults.standard.set(lastName, forKey: onboardingLastName)
                            UserDefaults.standard.set(email, forKey: onboardingEmail)
                            UserDefaults.standard.set(true, forKey: "appStateIsLoggedIn")
                            onboardingViewModel.isLoggedIn = true
                        }
                    } label: {
                        Text("Register")
                            .frame(width: UIScreen.main.bounds.width - 50, height: 35)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .background(Color(UIColor(red: 73 / 255, green: 94 / 255, blue: 87 / 255, alpha: 1)))
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                }
            }
            .navigationDestination(isPresented: $onboardingViewModel.isLoggedIn) {
                Home()
                    .environment(\.managedObjectContext, persistanceController.container.viewContext)
                    .environmentObject(onboardingViewModel)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Logo")
                }
            }
            .onAppear {
                onboardingViewModel.isLoggedIn = UserDefaults.standard.bool(forKey: "appStateIsLoggedIn")
            }
        }
    }
    
    
    private func checkForValidCredentials(completion: @escaping (() -> Void)) {
        // First Name / Last Name
        let nonEmptyCharactersForFirstName = firstName.replacingOccurrences(of: " ", with: "").isEmpty
        let nonEmptyCharactersForLastName = lastName.replacingOccurrences(of: " ", with: "").isEmpty
        // Email
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let validEmail = emailPred.evaluate(with: email)
        // Evaluate
        if !nonEmptyCharactersForFirstName && !nonEmptyCharactersForLastName && validEmail {
            completion()
        }
        if nonEmptyCharactersForFirstName {
            invalidFirstName = true
        } else {
            invalidFirstName = false
        }
        if nonEmptyCharactersForLastName {
            invalidLastName = true
        } else {
            invalidLastName = false
        }
        if !validEmail {
            invalidEmail = true
        } else {
            invalidEmail = false
        }
    }
    
}
