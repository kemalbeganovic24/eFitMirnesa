//
//  ActivitySelectionView.swift
//  eFitMirnesa
//
//  Created by Kemal Beganovic on 21. 8. 2026..
//

import SwiftUI

struct ActivitySelectionView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Unesi aktivnost!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                // PRVI RED: Članovi i Individualni Trening
                HStack(spacing: 15) {
                    NavigationLink(destination: KartoniClanovaView()) {
                        ActivityCard(title: "Članovi", icon: "person.3.fill")
                    }
                    
                    NavigationLink(destination: IndividualniTreningView()) {
                        ActivityCard(title: "Ind. Trening", icon: "person.fill.checkmark")
                    }
                }
                
                // DRUGI RED: Grupni Trening i Kalendar
                HStack(spacing: 15) {
                    NavigationLink(destination: GrupniTreningView()) {
                        ActivityCard(title: "Grupni", icon: "figure.cross.training")
                    }
                    
                    NavigationLink(destination: CalendarView()) {
                        ActivityCard(title: "Kalendar", icon: "calendar")
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct ActivityCard: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.black)
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.black)
        }
        .frame(width: 110, height: 90)
        .background(Color(red: 1.0, green: 0.75, blue: 0.82))
        .cornerRadius(15)
    }
}

#Preview {
    ActivitySelectionView()
        .environmentObject(MemberViewModel())
}
