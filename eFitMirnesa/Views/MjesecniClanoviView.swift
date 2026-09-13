import SwiftUI

struct MjesecniClanoviView: View {
    @EnvironmentObject var viewModel: MemberViewModel
    @State private var selectedDate = Date()
    
    // Izdvajanje Mjeseca i Godine iz izabranog datuma (npr. "Septembar 2026")
    private var selectedMonthYear: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "bs_BA") // Bosanski jezik za nazive mjeseci
        formatter.dateFormat = "LLLL yyyy."
        return formatter.string(from: selectedDate).capitalized
    }
    
    // Filtriranje članova po mjesecu i godini
    private var filteredMembers: [Member] {
        let calendar = Calendar.current
        let targetComponents = calendar.dateComponents([.year, .month], from: selectedDate)
        
        return viewModel.members.filter { member in
            // Ako član ima evidenciju uplatnica ili treninga za izabrani mjesec
            let hasPaymentThisMonth = member.paymentHistory.contains { payment in
                if let paymentDate = parseDate(payment.date) {
                    let comp = calendar.dateComponents([.year, .month], from: paymentDate)
                    return comp.year == targetComponents.year && comp.month == targetComponents.month
                }
                return false
            }
            
            let hasTrainingThisMonth = (member.trainingsHistory ?? []).contains { log in
                if let logDate = parseDate(log.date) {
                    let comp = calendar.dateComponents([.year, .month], from: logDate)
                    return comp.year == targetComponents.year && comp.month == targetComponents.month
                }
                return false
            }
            
            // Prikazuje člana ako ima uplate, treninge ili ako nema zapisa prikazuje u tekućem mjesecu
            return hasPaymentThisMonth || hasTrainingThisMonth
        }
    }
    
    // Pomagalo za konverziju String u Date
    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy."
        return formatter.string(for: dateString) != nil ? formatter.date(from: dateString) : nil
    }

    var body: some View {
        VStack(spacing: 15) {
            
            // Birač mjeseca
            HStack {
                Text("Izaberi mjesec:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .labelsHidden()
                    .datePickerStyle(.compact)
            }
            .padding(.horizontal)
            .padding(.top)

            // Naslov izabranog mjeseca
            HStack {
                Text("Članovi za: \(selectedMonthYear)")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("Ukupno: \(filteredMembers.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            // Lista članova
            if filteredMembers.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "person.2.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Nema evidentiranih članova za \(selectedMonthYear)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                List(filteredMembers) { member in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(member.name)
                                .font(.body)
                                .fontWeight(.semibold)
                            if let phone = member.phone, !phone.isEmpty {
                                Text(phone)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        Text(member.status)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Mjesečni pregled")
        .navigationBarTitleDisplayMode(.inline)
    }
}
