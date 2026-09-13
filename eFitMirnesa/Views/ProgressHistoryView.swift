import SwiftUI

struct ProgressHistoryView: View {
    @Binding var member: Member

    var body: some View {
        VStack {
            if member.measurements.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Nema zabilježenih mjera.")
                        .foregroundColor(.gray)
                }
                .padding()
                Spacer()
            } else {
                List {
                    ForEach(member.measurements.reversed()) { m in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                                Text("Datum: \(m.date)")
                                    .font(.headline)
                            }
                            
                            Divider()
                            
                            // Prikaz Kilaže
                            HStack {
                                Text("Težina:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(String(format: "%.1f", m.weight)) kg")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.6))
                            }
                            
                            // Grid/Lista svih obima
                            VStack(spacing: 6) {
                                HStack(spacing: 10) {
                                    MeasurementBadge(label: "Grudi", val: "\(m.chest) cm")
                                    MeasurementBadge(label: "Struk", val: "\(m.waist) cm")
                                    MeasurementBadge(label: "Kukovi", val: "\(m.hips) cm")
                                }
                                HStack(spacing: 10) {
                                    MeasurementBadge(label: "Ruke", val: "\(m.arms) cm")
                                    MeasurementBadge(label: "Noge", val: "\(m.legs) cm")
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationBarTitle("Historija napretka", displayMode: .inline)
    }
}

struct MeasurementBadge: View {
    let label: String
    let val: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(val)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(6)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
