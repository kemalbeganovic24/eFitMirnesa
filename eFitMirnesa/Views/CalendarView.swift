//
//  CalendarView.swift
//  eFitMirnesa
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: MemberViewModel
    
    @State private var selectedDate: Date = Date()
    @State private var selectedType: String = "grupni"
    
    private var selectedDayFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy."
        return formatter.string(from: selectedDate)
    }
    
    private var membersForSelectedDate: [(member: Member, note: String)] {
        var result: [(member: Member, note: String)] = []
        
        if selectedType == "grupni" {
            for member in viewModel.members {
                if let logs = member.trainingsHistory {
                    for log in logs {
                        if log.date == selectedDayFormatted && log.type.lowercased() == "grupni" {
                            result.append((member: member, note: log.note))
                        }
                    }
                }
            }
        } else {
            let trainingForDate = viewModel.trainings.first { $0.date == selectedDayFormatted }
            
            if let memberIds = trainingForDate?.selectedMemberIds {
                for id in memberIds {
                    if let member = viewModel.members.first(where: { $0.id == id }) {
                        result.append((member: member, note: trainingForDate?.note ?? ""))
                    }
                }
            }
        }
        
        return result
    }
    
    var body: some View {
        VStack(spacing: 15) {
            
            // 1. Prekidač za Tip treninga
            Picker("Tip treninga", selection: $selectedType) {
                Text("Grupni").tag("grupni")
                Text("Individualni").tag("individualni")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // 2. Kalendar
            DatePicker("Izaberi datum", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .accentColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                .padding(.horizontal)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
            
            // 3. Zaglavlje sa informacijom o datumu
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Prisutni za datum:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(selectedDayFormatted)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Text("Ukupno: \(membersForSelectedDate.count)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // 4. Lista prisutnih sa opcijom brisanja prevlačenjem
            if membersForSelectedDate.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text("Nema evidentiranih \(selectedType)h treninga za \(selectedDayFormatted).")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                Spacer()
            } else {
                List {
                    ForEach(membersForSelectedDate, id: \.member.id) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.member.name)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                
                                if !item.note.isEmpty {
                                    Text("Napomena: \(item.note)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .onDelete(perform: deleteTrainingLog)
                }
                .listStyle(PlainListStyle())
            }
        }
        .padding(.top, 10)
        .navigationTitle("Kalendar Treninga")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteTrainingLog(at offsets: IndexSet) {
        for index in offsets {
            let item = membersForSelectedDate[index]
            guard let memberId = item.member.id else { continue }
            
            if selectedType == "grupni" {
                viewModel.deleteGroupTrainingLog(
                    memberId: memberId,
                    logDate: selectedDayFormatted,
                    logNote: item.note
                )
            } else {
                if let training = viewModel.trainings.first(where: { $0.date == selectedDayFormatted }) {
                    viewModel.deleteTraining(training: training)
                }
            }
        }
    }
}
