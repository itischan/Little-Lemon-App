//
//  Menu.swift
//  LittleLemon
//
//  Created by Chandru Kumaran on 11/28/23
//

import SwiftUI
import CoreData

struct Home: View {
    // MARK: - References / Properties
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var onboardingViewModel: OnboardingViewModel
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]) var menuItems: FetchedResults<Dish>
    @State private var searchText: String = ""
    // Used for the search text field.
    var query: Binding<String> {
        Binding {
            searchText
        } set: { newValue in
            searchText = newValue
            menuItems.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS[cd] %@", newValue)
        }
    }
    private let foodType: [String] = ["Starters", "Mains", "Desserts", "Drinks"]
    @State private var profileActive: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Little Lemon")
                    .font(.custom("Markazi Text", size: 40))
                    .fontWeight(.medium)
                    .foregroundColor(Color(UIColor(red: 221 / 255, green: 187 / 255, blue: 19 / 255, alpha: 1)))
                    .padding(.top)
                Text("Chicago")
                    .font(.custom("Markazi Text", size: 25))
                    .foregroundColor(.white)
                HStack {
                    VStack(alignment: .leading) {
                        Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                            .font(.custom("Markazi Text", size: 18))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                    Spacer()
                    Image("HeroImage")
                        .resizable()
                        .frame(width: 125, height: 125)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }
                .padding(.top, 0)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 15, height: 15)
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                    TextField("", text: query)
                }
                .frame(height: 35)
                .background(
                    Color.white
                )
                .cornerRadius(10)
                .padding(.bottom)
            }
            .frame(height: UIScreen.main.bounds.height * 0.33)
            .padding(.horizontal, 8)
            .background(
                Color(UIColor(red: 73 / 255, green: 94 / 255, blue: 87 / 255, alpha: 1))
            )
            GeometryReader { reader in
                ScrollView {
                        // Type
                        VStack(alignment: .leading) {
                            Text("ORDER FOR DELIVERY!")
                                .font(.custom("Karla", size: 20))
                                .fontWeight(.bold)
                            HStack {
                                ForEach(foodType, id: \.self) { type in
                                    Text(type)
                                        .frame(width: reader.size.width / 4.5, height: 30)
                                        .background(
                                            Color(UIColor(red: 237 / 255, green: 239 / 255, blue: 238 / 255, alpha: 1))
                                        )
                                        .cornerRadius(15)
                                        .onTapGesture {
                                            getMenuData()
                                        }
                                }
                            }
                        }
                        .frame(width: reader.size.width, height: 100)
                            // Menu
                            ForEach(menuItems, id: \.title) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(item.title ?? "")")
                                            .font(.custom("Karla", size: 20))
                                            .fontWeight(.bold)
                                            .padding(.vertical, 2)
                                        Text("\(item.itemDescription ?? "")")
                                            .font(.custom("Karla", size: 16))
                                            .padding(.vertical, 2)
                                        Text("$\(item.price ?? "")")
                                            .font(.custom("Karla", size: 20))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(UIColor(red: 73 / 255, green: 94 / 255, blue: 87 / 255, alpha: 1)))
                                            .padding(.vertical, 2)
                                    }
                                    .padding(.leading, 8)
                                    Spacer()
                                    AsyncImage(url: URL(string: item.image ?? "")!) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: reader.size.width / 4, height: reader.size.width / 4)
                                    .padding(.trailing, 8)
                                }
                                .frame(width: reader.size.width, height: 150)
                                .overlay(Rectangle().frame(width: reader.size.width - 25, height: 1, alignment: .top).foregroundColor(Color(UIColor(red: 237 / 255, green: 239 / 255, blue: 238 / 255, alpha: 1))), alignment: .top)
                            }
                }
                .frame(width: reader.size.width, height: reader.size.height, alignment: .center)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.50)
            .padding(.bottom, 0)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("Logo")
                    .offset(x: 15)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                ZStack {
                    NavigationLink(value: "User Profile") {
                        Image("Profile")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                profileActive.toggle()
                            }
                    }
                }
                .navigationDestination(isPresented: $profileActive) {
                    UserProfile()
                        .environmentObject(onboardingViewModel)
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }
    
    
    private func getMenuData() {
        PersistenceController.shared.clear()
        let url = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let urlRequest = URLRequest(url: URL(string: url)!)
        let dataTask =  URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return
            }
            if let error = error {
                print("An error occurred fetching data from server. \(error.localizedDescription)")
            } else {
                if response.statusCode == 200 {
                    guard let data = data else {
                        print("An error occurred fetching data from server.")
                        return
                    }
                    do {
                        let menuList = try JSONDecoder().decode(MenuList.self, from: data)
                        Dish.createDishesFrom(menuItems: menuList.menu, viewContext)
                    } catch let error {
                        print("An error occurred fetching data from server. \(error.localizedDescription)")
                    }
                } else {
                    print("An error occurred fetching data from server. \(response.statusCode)")
                }
            }
        }
        dataTask.resume()
    }
    
}
