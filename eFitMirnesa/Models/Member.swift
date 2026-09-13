//
//  Member.swift
//  eFitMirnesa
//
//  Created by Kemal Beganovic on 21. 8. 2026..
//

import Foundation
import FirebaseFirestore

struct Member: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var status: String
    var phone: String?
    var birtDate: String?
    var paymentHistory: [Payment] = []
    var measurements: [Measurement] = []
    var trainingsHistory: [MemberTrainingLog]? = []
    
    var createdMonthYear: String
}

struct Payment: Identifiable, Codable {
    var id: String = UUID().uuidString
    let date: String
    let amount: String
}

struct Measurement: Identifiable, Codable {
    var id: String = UUID().uuidString
    let date: String
    var chest: Double
    var waist: Double
    var hips: Double
    var arms: Double
    var legs: Double
    var weight: Double
    var upperWaist: Double? // Gornji stomak
    var lowerWaist: Double? // Donji stomak
}

// Struktura za evidenciju pojedinačnog treninga
struct MemberTrainingLog: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    let date: String
    let note: String
    let type: String
}
