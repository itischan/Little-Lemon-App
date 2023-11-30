//
//  UserProfile.swift
//  LittleLemon
//
//  Created by Chandru Kumaran on 11/28/23
//

import SwiftUI

struct UserProfile: View {
    // MARK: - References / Properties
    @Environment(\.presentationMode) private var presentation
    @EnvironmentObject private var onboardingViewModel: OnboardingViewModel
    @State private var firstName: String? = ""
    @State private var lastName: String? = ""
    @State private var email: String? = ""
    @State private var editingInformation: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Personal Information")
                .font(.system(size: 22))
                .fontWeight(.semibold)
            InformationRow(rowTitle: "Profile Image") {
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75, height: 75)
            }
            if editingInformation {
                InformationRow(rowTitle: "First Name") {
                    HStack {
                        TextField("", text: $firstName.defaultValue(""))
                            .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                    .background(
                        Color.white
                    )
                    .border(.black, width: 0.5)
                }
                InformationRow(rowTitle: "Last Name") {
                    HStack {
                        TextField("", text: $lastName.defaultValue(""))
                            .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                    .background(
                        Color.white
                    )
                    .border(.black, width: 0.5)
                }
                InformationRow(rowTitle: "Email") {
                    HStack {
                        TextField("", text: $email.defaultValue(""))
                            .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                    .background(
                        Color.white
                    )
                    .border(.black, width: 0.5)
                }
            } else {
                InformationRow(rowTitle: "First Name") {
                    HStack {
                        Text("\(firstName ?? "")")
                            .font(.system(size: 16))
                            .padding()
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                    .background(
                        Color.white
                    )
                    .border(.black, width: 0.5)
                }
                InformationRow(rowTitle: "Last Name") {
                    HStack {
                        Text("\(lastName ?? "")")
                            .font(.system(size: 16))
                            .padding()
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                    .background(
                        Color.white
                    )
                    .border(.black, width: 0.5)
                }
                InformationRow(rowTitle: "Email") {
                    HStack {
                        Text("\(email ?? "")")
                            .font(.system(size: 16))
                            .padding()
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                    .background(
                        Color.white
                    )
                    .border(.black, width: 0.5)
                }
            }
            Spacer()
            Button {
                onboardingViewModel.isLoggedIn = false
                UserDefaults.standard.set(false, forKey: "appStateIsLoggedIn")
            } label: {
                Text("Logout")
                    .frame(width: UIScreen.main.bounds.width - 50, height: 35)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
            }
            .background(Color(UIColor(red: 221 / 255, green: 187 / 255, blue: 19 / 255, alpha: 1)))
            .cornerRadius(10)
            .padding(.bottom, 30)
        }
        .onAppear {
            firstName = UserDefaults.standard.string(forKey: onboardingFirstName)
            lastName = UserDefaults.standard.string(forKey: onboardingLastName)
            email = UserDefaults.standard.string(forKey: onboardingEmail)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("Logo")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(editingInformation ? "Save" : "Edit" ) {
                    if editingInformation {
                        saveInfo()
                        editingInformation.toggle()
                    } else {
                        editingInformation.toggle()
                    }
                }
                .foregroundColor(Color(UIColor(red: 73 / 255, green: 94 / 255, blue: 87 / 255, alpha: 1)))
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(UIColor(red: 73 / 255, green: 94 / 255, blue: 87 / 255, alpha: 1)))
                        .overlay(
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                        )
                }

            }
        }
    }
    
    
    /// Creates a row to be used in the UserProfile view.
    /// - Parameters:
    ///   - rowTitle: The row title.
    ///   - view: The view to be used and shown.
    /// - Returns: some View
    private func InformationRow(rowTitle: String, @ViewBuilder view: () -> some View) -> some View {
        VStack(alignment: .leading) {
            Text(rowTitle)
                .foregroundColor(.black)
                .font(.system(size: 16))
            view()
                .padding(.leading, 10)
        }
    }
    
    private func saveInfo() {
        UserDefaults.standard.set(firstName, forKey: onboardingFirstName)
        UserDefaults.standard.set(lastName, forKey: onboardingLastName)
        UserDefaults.standard.set(email, forKey: onboardingEmail)
        firstName = UserDefaults.standard.string(forKey: onboardingFirstName)
        lastName = UserDefaults.standard.string(forKey: onboardingLastName)
        email = UserDefaults.standard.string(forKey: onboardingEmail)
    }
    
}


// MARK: - Binding Extension
extension Binding {
    
    func defaultValue<T>(_ defaultValue: T) -> Binding<T> where Value == Optional<T> {
        return Binding<T>(get: {
            self.wrappedValue ?? defaultValue
        }, set: { newValue in
            self.wrappedValue = newValue
        })
    }
    
}
