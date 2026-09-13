import SwiftUI

struct IndividualniTreningView: View {
    @EnvironmentObject var viewModel: MemberViewModel
    @State private var selectedMemberIds: Set<String> = []
    @State private var note: String = ""
    @State private var showSuccessAlert = false
    
    @State private var selectedMonthDate = Date()
    
    // TRENUTNI DATUM ZA EVIDENCIJU TRENINGA (Default: Danas)
    @State private var selectedDate: Date = Date()

    private var selectedMonthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.yyyy"
        return formatter.string(from: selectedMonthDate)
    }
    
    // Formatira izabrani datum u "dd.MM.yyyy."
    private var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy."
        return formatter.string(from: selectedDate)
    }
    
    private var filteredMembers: [Member] {
        viewModel.members.filter { member in
            let memberMonth = member.createdMonthYear ?? ""
            return memberMonth == selectedMonthYearString
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // --- SELEKTOR DATUMA TRENINGA (AUTOMATSKI DANAŠNJI DATUM) ---
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Datum treninga:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Text(formattedSelectedDate)
                            .font(.caption)
                            .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                    }
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
                
                // --- SELEKTOR MJESECA ZA FILTRIRANJE ČLANOVA ---
                HStack {
                    Text("Filtriraj članove po mjesecu:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    Spacer()
                    DatePicker(
                        "",
                        selection: $selectedMonthDate,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // ODABIR ČLANOVA
                VStack(alignment: .leading, spacing: 10) {
                    Text("Odaberi prisutne članove za (\(selectedMonthYearString)):")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    if filteredMembers.isEmpty {
                        Text("Nema registrovanih članova za izabrani mjesec.")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding(.vertical, 5)
                    } else {
                        ForEach(filteredMembers) { member in
                            let memberID = member.id ?? ""
                            
                            HStack {
                                Text(member.name)
                                    .fontWeight(.medium)
                                Spacer()
                                
                                Image(systemName: selectedMemberIds.contains(memberID) ? "checkmark.square.fill" : "square")
                                    .font(.title2)
                                    .foregroundColor(selectedMemberIds.contains(memberID) ? Color(red: 0.9, green: 0.4, blue: 0.6) : .gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .onTapGesture {
                                if !memberID.isEmpty {
                                    toggleSelection(for: memberID)
                                }
                            }
                        }
                    }
                }
                
                // NAPOMENA
                VStack(alignment: .leading, spacing: 8) {
                    Text("Napomena / Opis treninga:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    TextField("npr. Trening snage - noge i ramena", text: $note)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                // DUGME ZA EVIDENCIJU
                Button(action: saveCurrentTraining) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Evidentiraj Trening (\(formattedSelectedDate))")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedMemberIds.isEmpty ? Color.gray : Color(red: 0.9, green: 0.4, blue: 0.6))
                    .cornerRadius(12)
                }
                .disabled(selectedMemberIds.isEmpty)
                
                Divider().padding(.vertical, 10)
                
                // HISTORIJA TRENINGA SA DUGMETOM ZA BRISANJE
                VStack(alignment: .leading, spacing: 10) {
                    Text("Historija individualnih treninga")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if viewModel.trainings.isEmpty {
                        Text("Još nema evidentiranih treninga.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.trainings.reversed()) { training in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Datum: \(training.date)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                                    
                                    Spacer()
                                    
                                    Text("\(training.selectedMemberIds.count) član(a)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    // DUGME ZA BRISANJE TRENINGA
                                    Button(action: {
                                        viewModel.deleteTraining(training: training)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .font(.subheadline)
                                            .padding(.leading, 8)
                                    }
                                }
                                
                                Text("Prisutni: " + getMemberNames(for: training.selectedMemberIds))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                if !training.note.isEmpty {
                                    Text("Napomena: \(training.note)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.08))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Individualni Trening")
        .alert("Trening Evidentiran!", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    private func toggleSelection(for id: String) {
        if selectedMemberIds.contains(id) {
            selectedMemberIds.remove(id)
        } else {
            selectedMemberIds.insert(id)
        }
    }
    
    private func saveCurrentTraining() {
        viewModel.saveTraining(
            memberIds: Array(selectedMemberIds),
            note: note,
            date: formattedSelectedDate // <<--- Proslijeđuje izabrani datum (npr. "18.09.2026.")
        )
        
        selectedMemberIds.removeAll()
        note = ""
        selectedDate = Date() // Resetuje kalendar nazad na današnji dan
        showSuccessAlert = true
    }
    
    private func getMemberNames(for ids: [String]) -> String {
        let names = viewModel.members
            .filter { ids.contains($0.id ?? "") }
            .map { $0.name }
        return names.joined(separator: ", ")
    }
}

#Preview {
    NavigationView {
        IndividualniTreningView()
            .environmentObject(MemberViewModel())
    }
}
