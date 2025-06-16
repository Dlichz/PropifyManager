//
//  ContractView.swift
//  Propify
//
//  Created by Francisco David Zárate Vásquez on 15/02/25.
//

import SwiftUI

struct ContractView: View {
    let tenant: Inquilino
    
    var body: some View {
        VStack {
            Text("Contrato de Arrendamiento")
                .font(.title)
                .bold()
                .padding()
            
            ScrollView {
                Text("""
                CONTRATO DE ARRENDAMIENTO

                Entre los suscritos:

                Propietario: [Nombre completo del propietario], identificado con [tipo de identificación, número de identificación], domiciliado en [dirección del propietario], en adelante "EL PROPIETARIO".
                Inquilino:
                Se celebra el presente contrato de arrendamiento, sujeto a las siguientes cláusulas y condiciones:

                PRIMERA: OBJETO DEL CONTRATO

                EL PROPIETARIO cede en arrendamiento a EL INQUILINO el departamento ubicado en [dirección completa del departamento], el cual consta de:

                1 recámara.
                1 estancia.
                1 baño completo.
                Servicios incluidos: Internet.
                Servicios no incluidos: La luz se cobrará según el recibo del mes.
                SEGUNDA: DURACIÓN DEL CONTRATO

                El presente contrato tendrá una vigencia de:

                Fecha de inicio:
                Fecha de finalización:
                
                TERCERA: RENTA MENSUAL

                EL INQUILINO se obliga a pagar una renta mensual de $[monto de la renta] (en números y letras), la cual deberá ser cubierta los días [día del mes] de cada mes, en la siguiente cuenta bancaria o en el domicilio del propietario:

                Banco: [Nombre del banco].
                Cuenta: [Número de cuenta].
                Titular: [Nombre del titular].
                CUARTA: DEPÓSITO DE GARANTÍA

                EL INQUILINO entregará a EL PROPIETARIO un depósito de garantía equivalente a $[monto del depósito] (en números y letras), el cual será devuelto al término del contrato, siempre y cuando el departamento se encuentre en las mismas condiciones en que fue entregado, sin deducciones por daños o reparaciones.

                QUINTA: OBLIGACIONES DEL INQUILINO

                EL INQUILINO se obliga a:

                Pagar puntualmente la renta mensual y los servicios no incluidos (luz).
                Mantener el departamento en buen estado, realizando las reparaciones menores que sean necesarias.
                No realizar modificaciones al departamento sin la autorización por escrito de EL PROPIETARIO.
                No subarrendar el departamento total o parcialmente.
                No permitir la entrada de mascotas al departamento.
                Entregar el departamento en las mismas condiciones en que lo recibió al término del contrato.
                SEXTA: OBLIGACIONES DEL PROPIETARIO

                EL PROPIETARIO se obliga a:

                Entregar el departamento en condiciones habitables y con los servicios contratados en funcionamiento.
                Realizar las reparaciones mayores que sean necesarias para mantener el departamento en buen estado.
                Respetar la privacidad de EL INQUILINO, notificando con anticipación cualquier visita al departamento.
                SÉPTIMA: PROHIBICIÓN DE MASCOTAS

                Queda estrictamente prohibido que EL INQUILINO tenga mascotas en el departamento. En caso de incumplimiento, EL PROPIETARIO podrá dar por terminado el contrato de manera inmediata.

                OCTAVA: TERMINACIÓN DEL CONTRATO

                El contrato podrá terminar por:

                Vencimiento del plazo establecido.
                Incumplimiento de alguna de las cláusulas por parte de EL INQUILINO.
                Mutuo acuerdo entre las partes.
                En caso de terminación anticipada, EL INQUILINO deberá notificar con [número de días] días de anticipación y cubrir cualquier adeudo pendiente.

                NOVENA: JURISDICCIÓN Y LEY APLICABLE

                Para cualquier controversia derivada del presente contrato, las partes se someten a los tribunales competentes de [ciudad, estado], renunciando a cualquier otra jurisdicción que pudiera corresponderles.

                FIRMAS DE CONFORMIDAD:

                EL PROPIETARIO
                [Nombre completo]
                Firma: ___________________________
                Fecha:
                EL INQUILINO
                Firma: ___________________________
                Fecha:
                """)
                .padding()
            }
        }
        .padding()
    }
}
