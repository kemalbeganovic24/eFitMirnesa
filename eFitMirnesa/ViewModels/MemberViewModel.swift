import SwiftUI
import Foundation
import FirebaseFirestore
import Combine

class MemberViewModel: ObservableObject {
    @Published var members: [Member] = []
    @Published var trainings: [IndividualTraining] = []
    private var db = Firestore.firestore()
    
    init() {
        fetchMembers()
        fetchTrainings() // Sluh za treninge
    }
    
    func fetchMembers() {
        db.collection("members").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Greška pri dohvatanju članova: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            
            self.members = documents.compactMap { document in
                try? document.data(as: Member.self)
            }
            
            self.updateExistingMembersMonth(defaultMonthYear: "09.2026")
        }
    }
    
    private func updateExistingMembersMonth(defaultMonthYear: String) {
        for member in members {
            if member.createdMonthYear == nil, let id = member.id {
                db.collection("members").document(id).updateData([
                    "createdMonthYear": defaultMonthYear
                ]) { error in
                    if let error = error {
                        print("Greška pri ažuriranju člana \(member.name): \(error.localizedDescription)")
                    } else {
                        print("Uspješno dodijeljen mjesec \(defaultMonthYear) za člana: \(member.name)")
                    }
                }
            }
        }
    }
    
    // Sluh za treninge iz Firestore baze
    func fetchTrainings() {
        db.collection("trainings").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Greška pri dohvatanju treninga: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            
            self.trainings = documents.compactMap { document in
                try? document.data(as: IndividualTraining.self)
            }
        }
    }
    
    // Funkcija za dodavanje člana u Firebase sa registrovanim mjesecom kreiranja
    func addMember(name: String, phone: String, birthDate: String, createdMonthYear: String) {
        let newMember = Member(
            name: name,
            status: "Aktivan",
            phone: phone,
            birtDate: birthDate,
            paymentHistory: [],
            measurements: [],
            trainingsHistory: [],
            createdMonthYear: createdMonthYear
        )
        
        do {
            _ = try db.collection("members").addDocument(from: newMember)
        } catch {
            print("Greška pri spajanju novog člana: \(error.localizedDescription)")
        }
    }
    
    func updateMember(member: Member) {
        guard let id = member.id else { return }
        do {
            try db.collection("members").document(id).setData(from: member)
        } catch {
            print("Greška pri ažuriranju člana: \(error.localizedDescription)")
        }
    }
    
    func saveTraining(memberIds: [String], note: String, date: String) {
        let newTraining = IndividualTraining(
            date: date,
            selectedMemberIds: memberIds,
            note: note
        )
        
        do {
            _ = try db.collection("trainings").addDocument(from: newTraining)
        } catch {
            print("Greška pri čuvanju treninga u Firebase: \(error.localizedDescription)")
        }
    }
    
    func deleteMember(member: Member) {
        guard let id = member.id else { return }
        
        db.collection("members").document(id).delete { error in
            if let error = error {
                print("Greška pri brisanju člana: \(error.localizedDescription)")
            } else {
                print("Član uspješno obrisan.")
            }
        }
    }
    
    func deleteTraining(training: IndividualTraining) {
        guard let id = training.id, !id.isEmpty else { return }
        
        db.collection("trainings").document(id).delete { error in
            if let error = error {
                print("Greška pri brisanju treninga: \(error.localizedDescription)")
            } else {
                print("Trening uspješno obrisan.")
            }
        }
    }
    
    func saveGroupTrainingForMembers(memberIds: [String], note: String, date: String) {
        for memberId in memberIds {
            if let index = members.firstIndex(where: { $0.id == memberId }) {
                var updatedMember = members[index]
                if updatedMember.trainingsHistory == nil {
                    updatedMember.trainingsHistory = []
                }
                
                let newLog = MemberTrainingLog(
                    date: date,
                    note: note,
                    type: "grupni"
                )
                
                updatedMember.trainingsHistory?.append(newLog)
                updateMember(member: updatedMember)
            }
        }
    }
    func deleteGroupTrainingLog(memberId: String, logDate: String, logNote: String) {
        guard let index = members.firstIndex(where: { $0.id == memberId }) else { return }
        var updatedMember = members[index]
        
        // Filtriramo istoriju i izbacujemo zapis sa izabranim datumom i napomenom
        updatedMember.trainingsHistory?.removeAll(where: { log in
            log.date == logDate && log.note == logNote && log.type.lowercased() == "grupni"
        })
        
        updateMember(member: updatedMember)
    }
}
