//
//  DodajClanaView.swift
//  eFitMirnesa
//

import SwiftUI

struct DodajClanaView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MemberViewModel
    
    @State private var name = ""
    @State private var birthDate = ""
    @State private var phone = ""
    
    // Novo stanje za izbor mjeseca upisa (podrazumijevano trenutni datum)
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Dodavanje novog člana")
                    .font(.headline)
                    .padding(.top)

                TextField("Ime i prezime", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                TextField("Datum rođenja", text: $birthDate)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                TextField("Broj telefona", text: $phone)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                // Izbor mjeseca i godine učlanjenja
                HStack {
                    Text("Mjesec učlanjenja:")
                        .fontWeight(.medium)
                    Spacer()
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

                // --- DUGME ZA KALENDAR TRENINGA ---
                NavigationLink(destination: CalendarView()) {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.title2)
                        Text("Kalendar treninga")
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .padding()
                    .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                    .background(Color(red: 0.9, green: 0.4, blue: 0.6).opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.top, 5)

                Spacer()

                Button(action: {
                    if !name.isEmpty {
                        // Pretvaramo izabrani datum iz DatePicker-a u format MM.yyyy (npr. "10.2026")
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM.yyyy"
                        let formattedMonthYear = formatter.string(from: selectedDate)
                        
                        viewModel.addMember(
                            name: name,
                            phone: phone,
                            birthDate: birthDate,
                            createdMonthYear: formattedMonthYear
                        )
                        
                        dismiss()
                    }
                }) {
                    Text("Nastavi")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    DodajClanaView()
        .environmentObject(MemberViewModel())
}
