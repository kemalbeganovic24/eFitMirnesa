import SwiftUI

struct OClanuView: View {
    @EnvironmentObject var viewModel: MemberViewModel
    @Environment(\.dismiss) var dismiss // Omogućava povratak nazad nakon brisanja
    
    @Binding var member: Member

    @State private var chestInput: String = ""
    @State private var upperWaistInput: String = "" // Gornji stomak
    @State private var lowerWaistInput: String = "" // Donji stomak
    @State private var waistInput: String = ""      // Obim struka
    @State private var hipsInput: String = ""
    @State private var armsInput: String = ""
    @State private var legsInput: String = ""
    @State private var weightInput: String = ""
    @State private var searchText: String = ""
    
    // Stanja za brisanje
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Card
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ime i prezime člana")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    TextField("Ime člana", text: $member.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Tel: \(member.phone ?? "/")  |  Rođena: \(member.birtDate ?? "/")")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(red: 0.9, green: 0.4, blue: 0.6))
                .cornerRadius(15)

                // 1. DUGME ZA HISTORIJU PLAĆANJA
                NavigationLink(destination: PaymentHistoryView(member: $member)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Plaćanje članarine")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text("Evidencija i pregled uplata")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "creditcard.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }

                // 2. DUGME ZA HISTORIJU NAPRETKA
                NavigationLink(destination: ProgressHistoryView(member: $member)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Historija napretka")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text("Pregled svih prethodnih mjerenja")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // 3. DUGME ZA HISTORIJU TRENINGA (Pregled posjećenosti člana)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Prisustvo na treninzima")
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "figure.run")
                            .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                    }
                    
                    if let trainings = member.trainingsHistory, !trainings.isEmpty {
                        ForEach(trainings.reversed(), id: \.id) { log in
                            HStack {
                                Text(log.date)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(log.note.isEmpty ? "Trening odrađen" : log.note)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    } else {
                        Text("Nema evidentiranih treninga.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

                // Unos novih mjera
                VStack(alignment: .leading, spacing: 10) {
                    Text("Unos novih mjera (cm)")
                        .fontWeight(.bold)
                    
                    VStack(spacing: 10) {
                        MeasureInputRow(title: "Težina (kg)", value: $weightInput, keyboardType: .decimalPad)
                        MeasureInputRow(title: "Obim grudi", value: $chestInput)
                        MeasureInputRow(title: "Gornji stomak", value: $upperWaistInput)
                        MeasureInputRow(title: "Donji stomak", value: $lowerWaistInput)
                        MeasureInputRow(title: "Obim struka", value: $waistInput)
                        MeasureInputRow(title: "Obim stražnjice", value: $hipsInput)
                        MeasureInputRow(title: "Obim ruku", value: $armsInput)
                        MeasureInputRow(title: "Obim nogu", value: $legsInput)
                    }
                }

                Spacer(minLength: 10)

                // Dugme za spašavanje promjena
                Button(action: saveChanges) {
                    Text("Završi i Sačuvaj")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
                
                // 4. DUGME ZA BRISANJE ČLANA
                Button(role: .destructive, action: {
                    showDeleteConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Obriši člana")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.15))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationBarTitle("O članu", displayMode: .inline)
        .onAppear(perform: loadCurrentMeasurements)
        // Dijalog potvrde brisanja
        .alert("Brisanje člana", isPresented: $showDeleteConfirmation) {
            Button("Obriši", role: .destructive) {
                viewModel.deleteMember(member: member)
                dismiss() // Zatvara karton i vraća na listu
            }
            Button("Odustani", role: .cancel) { }
        } message: {
            Text("Jeste li sigurni da želite obrisati člana \(member.name)? Akcija se ne može poništiti.")
        }
    }

    private func loadCurrentMeasurements() {
        if let last = member.measurements.last {
            chestInput = last.chest > 0 ? String(last.chest) : ""
            upperWaistInput = (last.upperWaist ?? 0) > 0 ? String(last.upperWaist!) : ""
            lowerWaistInput = (last.lowerWaist ?? 0) > 0 ? String(last.lowerWaist!) : ""
            waistInput = last.waist > 0 ? String(last.waist) : ""
            hipsInput = last.hips > 0 ? String(last.hips) : ""
            armsInput = last.arms > 0 ? String(last.arms) : ""
            legsInput = last.legs > 0 ? String(last.legs) : ""
            weightInput = last.weight > 0 ? String(last.weight) : ""
        }
    }

    private func saveChanges() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy."
        let currentDate = formatter.string(from: Date())
        
        // Pomoćna funkcija za pretvaranje teksta sa zarezom u Double
        func parseDouble(_ input: String) -> Double {
            // Zamjenjuje zarez tačkom i uklanja prazne razmake
            let cleanedInput = input.trimmingCharacters(in: .whitespaces)
                                    .replacingOccurrences(of: ",", with: ".")
            return Double(cleanedInput) ?? 0.0
        }
        
        let newMeasurement = Measurement(
            date: currentDate,
            chest: parseDouble(chestInput),
            waist: parseDouble(waistInput),
            hips: parseDouble(hipsInput),
            arms: parseDouble(armsInput),
            legs: parseDouble(legsInput),
            weight: parseDouble(weightInput),
            upperWaist: parseDouble(upperWaistInput),
            lowerWaist: parseDouble(lowerWaistInput)
        )
        
        member.measurements.append(newMeasurement)
        viewModel.updateMember(member: member)
    }
}

struct MeasureInputRow: View {
    let title: String
    @Binding var value: String
    var keyboardType: UIKeyboardType = .numbersAndPunctuation
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            TextField("0", text: $value)
                .multilineTextAlignment(.trailing)
                .keyboardType(keyboardType)
                .frame(width: 80)
                .padding(6)
                .background(Color.white)
                .cornerRadius(6)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
