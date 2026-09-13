//
//  PaymentHistoryview.swift
//  eFitMirnesa
//
//  Created by Kemal Beganovic on 27. 8. 2026..
//

import SwiftUI

struct PaymentHistoryView: View {
    @EnvironmentObject var viewModel: MemberViewModel
    @Binding var member: Member
    
    @State private var inputDate: String = ""
    @State private var inputAmount: String = ""

    var body: some View {
        VStack(spacing: 15) {
            // Forma za bilježenje nove uplate
            VStack(alignment: .leading, spacing: 10) {
                Text("Evidentiraj novu uplatu")
                    .font(.headline)
                
                HStack(spacing: 10) {
                    TextField("Datum (npr. 27.08.2026.)", text: $inputDate)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    TextField("Iznos", text: $inputAmount)
                        .frame(width: 90)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                
                Button(action: addPayment) {
                    Label("Dodaj uplatu", systemImage: "plus.circle.fill")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color(red: 0.9, green: 0.4, blue: 0.6))
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            // Lista prethodnih uplata
            Text("Historija uplata")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)

            if member.paymentHistory.isEmpty {
                Text("Nema zabilježenih uplata.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(member.paymentHistory.reversed()) { payment in
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                            Text(payment.date)
                                .font(.subheadline)
                            Spacer()
                            Text(payment.amount)
                                .fontWeight(.bold)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding()
        .navigationBarTitle("Historija plaćanja", displayMode: .inline)
    }

    private func addPayment() {
        guard !inputAmount.isEmpty else { return }
        let newPayment = Payment(date: inputDate, amount: inputAmount)
        member.paymentHistory.append(newPayment)
        viewModel.updateMember(member: member)
        inputAmount = ""
    }
}
