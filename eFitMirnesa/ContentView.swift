import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MemberViewModel()

    var body: some View {
        TabView {
            // 1. Članovi
            NavigationView {
                MjesecniClanoviView()
            }
            .tabItem {
                Label("Članovi", systemImage: "person.3.fill")
            }
            
            // 2. GRUPNI TRENING (Novi ekran)
            NavigationView {
                GrupniTreningView()
            }
            .tabItem {
                Label("Grupni", systemImage: "figure.cross.training")
            }

            // 3. Individualni Trening
            NavigationView {
                IndividualniTreningView()
            }
            .tabItem {
                Label("Individualni", systemImage: "person.fill.checkmark")
            }

            // 4. Kalendar
            NavigationView {
                CalendarView()
            }
            .tabItem {
                Label("Kalendar", systemImage: "calendar")
            }
        }
        .environmentObject(viewModel)
    }
}
