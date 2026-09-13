import SwiftUI

struct GrupniTreningView: View {
    @EnvironmentObject var viewModel: MemberViewModel
    @State private var selectedMemberIds: Set<String> = []
    @State private var note: String = ""
    @State private var showSuccessAlert = false
    
    @State private var selectedMonthDate = Date()
    @State private var selectedDate: Date = Date()

    private var selectedMonthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.yyyy"
        return formatter.string(from: selectedMonthDate)
    }
    
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
                
                // --- SELEKTOR DATUMA (DANAŠNJI ILI IZABRANI DATUM) ---
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Datum grupnog treninga:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Text(formattedSelectedDate)
                            .font(.caption)
                            .foregroundColor(.blue)
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
                
                // --- FILTRIRANJE ČLANOVA ---
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
                
                // --- SELEKCIJA ČLANOVA ZA GRUPNI TRENING ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("Odaberi prisutne na grupnom treningu:")
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
                                    .foregroundColor(selectedMemberIds.contains(memberID) ? .blue : .gray)
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
                
                // --- NAPOMENA ---
                VStack(alignment: .leading, spacing: 8) {
                    Text("Napomena / Opis grupnog treninga:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    TextField("npr. Kardio + trbušnjaci", text: $note)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                // --- DUGME ZA EVIDENCIJU GRUPNOG TRENINGA ---
                Button(action: saveGroupTraining) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Evidentiraj GRUPNI Trening (\(formattedSelectedDate))")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedMemberIds.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
                }
                .disabled(selectedMemberIds.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Grupni Trening")
        .alert("Grupni Trening Evidentiran!", isPresented: $showSuccessAlert) {
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
    
    private func saveGroupTraining() {
        // Poziva funkciju u ViewModelu koja upisuje "grupni" tip u karton svakog izabranog člana
        viewModel.saveGroupTrainingForMembers(
            memberIds: Array(selectedMemberIds),
            note: note,
            date: formattedSelectedDate
        )
        
        selectedMemberIds.removeAll()
        note = ""
        selectedDate = Date()
        showSuccessAlert = true
    }
}
