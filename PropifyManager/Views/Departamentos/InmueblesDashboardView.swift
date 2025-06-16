import SwiftUI

struct InmueblesDashboardView: View {
    @StateObject private var viewModel = InmueblesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Statistics Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(title: "Total", value: "\(viewModel.totalInmuebles)", color: .blue)
                        StatCard(title: "Disponibles", value: "\(viewModel.inmueblesDisponibles)", color: .green)
                        StatCard(title: "Ocupados", value: "\(viewModel.inmueblesOcupados)", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // Properties List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Inmuebles")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.inmuebles) { inmueble in
                            NavigationLink(destination: InmuebleDetailView(inmueble: inmueble)) {
                                InmuebleRowView(inmueble: inmueble)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Mis inmuebles")
            .onAppear {
                viewModel.loadInmuebles()
            }
        }
    }
}

#Preview {
    InmueblesDashboardView()
} 
