//
//  LoginView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 23/04/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
//    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("Inicia sesión")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 16) {
                TextField("Correo electrónico", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                ZStack(alignment: .trailing) {
                    Group {
                        if isSecure {
                            SecureField("Contraseña", text: $password)
                        } else {
                            TextField("Contraseña", text: $password)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                    }
                }
            }
            .padding(.horizontal)

            Button(action: {
                // Aquí puedes agregar tu lógica de autenticación
//                viewModel.isAuthenticated = true
                print("Iniciando sesión con \(email)")
            }) {
                Text("Entrar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Button(action: {
                // Acción para recuperar contraseña (puede abrir otra vista)
            }) {
                Text("¿Olvidaste tu contraseña?")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
