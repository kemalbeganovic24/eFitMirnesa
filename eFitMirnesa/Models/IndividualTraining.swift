//
//  IndividualTraining.swift
//  eFitMirnesa
//
//  Created by Kemal Beganovic on 27. 8. 2026..
//

import Foundation
import FirebaseFirestore

struct IndividualTraining: Identifiable, Codable {
    @DocumentID var id: String?
    var date: String
    var selectedMemberIds: [String] // ID-jevi prisutnih članova
    var note: String
}
