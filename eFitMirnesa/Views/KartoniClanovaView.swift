import SwiftUI

struct KartoniClanovaView: View {
    @EnvironmentObject var viewModel: MemberViewModel
    @State private var showAddMember = false
    @State private var searchText: String = ""
    @State private var selectedMonthDate: Date = Date()
    @State private var memberToDelete: Member? = nil
    @State private var showDeleteConfirmation = false

    private var selectedMonthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "bs_BA")
        formatter.dateFormat = "LLLL yyyy."
        return formatter.string(from: selectedMonthDate).capitalized
    }

    // Filtriranje: Prikazuje samo članove kreirane u izabranom mjesecu ILI koji imaju uplatu u tom mjesecu
    var filteredMembers: [Binding<Member>] {
        let calendar = Calendar.current
        let targetMonth = calendar.component(.month, from: selectedMonthDate)
        let targetYear = calendar.component(.year, from: selectedMonthDate)
        let targetMonthYearString = String(format: "%02d.%d", targetMonth, targetYear)
        
        return $viewModel.members.filter { $member in
            // 1. Provjera da li je član kreiran u ovom mjesecu
            let isCreatedInSelectedMonth = member.createdMonthYear == targetMonthYearString
            
            // 2. Provjera da li član ima uplatu u ovom mjesecu
            let hasPaymentInSelectedMonth = member.paymentHistory.contains { payment in
                let components = payment.date.components(separatedBy: ".")
                if components.count >= 3,
                   let pMonth = Int(components[1]),
                   let pYear = Int(components[2]) {
                    return pMonth == targetMonth && pYear == targetYear
                }
                return false
            }
            
            let belongsToSelectedMonth = isCreatedInSelectedMonth || hasPaymentInSelectedMonth
            let matchesSearch = searchText.isEmpty || member.name.lowercased().contains(searchText.lowercased())
            
            return belongsToSelectedMonth && matchesSearch
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            // Header
            VStack(spacing: 8) {
                Text("GIRL POWER FITNESS")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Text("eFitMirnesa")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 12) {
                    Button(action: { showAddMember = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.badge.plus")
                            Text("Dodaj člana")
                        }
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                    
                    NavigationLink(destination: CalendarView()) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                            Text("Kalendar")
                        }
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.9, green: 0.4, blue: 0.6))
            .cornerRadius(15)
            .padding(.horizontal)
            .padding(.top, 5)
            
            // Birač mjeseca
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                }
                
                Spacer()
                
                Text(selectedMonthTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 4)

            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Pretraži u ovom mjesecu...", text: $searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color.gray.opacity(0.12))
            .cornerRadius(10)
            .padding(.horizontal)

            // Lista članova
            ScrollView {
                VStack(spacing: 12) {
                    if filteredMembers.isEmpty {
                        VStack(spacing: 8) {
                            Spacer(minLength: 30)
                            Image(systemName: "calendar.badge.plus")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("Nema članova za \(selectedMonthTitle)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                    } else {
                        ForEach(filteredMembers, id: \.id) { $member in
                            HStack {
                                NavigationLink(destination: OClanuView(member: $member)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(member.name)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                            Text(member.status)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                }
                                
                                Button(action: {
                                    memberToDelete = member
                                    showDeleteConfirmation = true
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding(8)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 5)
            }
        }
        .navigationBarTitle("Kartoni članova", displayMode: .inline)
        .sheet(isPresented: $showAddMember) {
            DodajClanaView()
        }
        .alert("Brisanje člana", isPresented: $showDeleteConfirmation, presenting: memberToDelete) { member in
            Button("Obriši", role: .destructive) {
                viewModel.deleteMember(member: member)
            }
            Button("Odustani", role: .cancel) { }
        } message: { member in
            Text("Jeste li sigurni da želite trajno obrisati člana \(member.name)?")
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedMonthDate) {
            selectedMonthDate = newDate
        }
    }
}
