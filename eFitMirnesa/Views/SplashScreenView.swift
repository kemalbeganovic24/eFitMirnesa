import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ActivitySelectionView()
        } else {
            ZStack {
                Color(red: 1.0, green: 0.75, blue: 0.82)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image("mirnesa")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220) // Povećano radi bolje vidljivosti
                    
                    VStack(spacing: 5) {
                        Text("GIRL POWER FITNESS")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        
                        Text("eFit Mirnesa")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.7))
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(MemberViewModel())
}
