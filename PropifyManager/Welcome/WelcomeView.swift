//
//  WelcomeView.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 23/04/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        
        VStack(spacing: 40){
            Spacer()
            
            //Logo o nombre de la app
            Text("Propify")
                .font(.system(size: 48, weight: .bold, design: .rounded ))
            
            //TagLine
            Text("Propify")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
            
            Spacer()
            
            //Botones
            VStack(spacing: 20){
                NavigationLink(destination: LoginView()){
                    Text("Iniciar Sesión")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 40)
                }
                
            }
            
            VStack(spacing: 20){
                NavigationLink(destination: LoginView()){
                    Text("Registrar")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 40)
                }
                
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
