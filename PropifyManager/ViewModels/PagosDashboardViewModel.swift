//
//  PagosDashboardViewModel.swift
//  PropifyManager
//
//  Created by Francisco David Zárate Vásquez on 13/06/25.
//

import SwiftUI
import Combine

class PagosDashboardViewModel: ObservableObject {
    @Published var resumenFinanciero: ResumenFinanciero
    @Published var pagos: [Pago] = []
    @Published var gastos: [Gasto] = []
    @Published var estadisticasMensuales: [EstadisticaMensual] = []
    @Published var estadisticasPorInmueble: [EstadisticaPorInmueble] = []
    @Published var alertas: [AlertaPago] = []
    
    // Filtros para el historial de pagos
    @Published var filtroFecha: DateFilter = .todos
    @Published var filtroInquilino: String = ""
    @Published var filtroEstado: EstadoPago? = nil
    @Published var fechaInicio: Date = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
    @Published var fechaFin: Date = Date()
    
    // Datos de muestra (en una app real vendrían de una base de datos)
    @Published var contratos: [Contrato] = []
    @Published var inquilinos: [Inquilino] = []
    @Published var inmuebles: [Inmueble] = []
    
    enum DateFilter: String, CaseIterable {
        case todos = "Todos"
        case esteMes = "Este Mes"
        case mesPasado = "Mes Pasado"
        case ultimos3Meses = "Últimos 3 Meses"
        case ultimos6Meses = "Últimos 6 Meses"
        case personalizado = "Personalizado"
    }
    
    init() {
        // Inicializar con datos de muestra
        self.resumenFinanciero = ResumenFinanciero(
            ingresosTotales: 0,
            egresosTotales: 0,
            balance: 0,
            pagosPendientes: 0,
            pagosVencidos: 0,
            periodo: "Enero 2025"
        )
        
        cargarDatosDeMuestra()
        calcularResumenFinanciero()
        generarEstadisticas()
        generarAlertas()
    }
    
    private func cargarDatosDeMuestra() {
        // Crear datos de muestra para demostración
        let inmueble1 = Inmueble(
            id: UUID(),
            type: .Departamento,
            name: "Departamento Centro",
            direccion: Direccion(
                id: UUID(),
                calle: "Reforma",
                numeroExterior: "123",
                numeroInterior: "A",
                colonia: "Centro",
                municipio: "Cuauhtémoc",
                estado: "CDMX",
                pais: "México",
                codigoPostal: "06000",
                apodo: "Centro",
                latitud: 19.4326,
                longitud: -99.1332
            ),
            metrosCuadrados: 80.0,
            rentaMensual: 15000.0,
            ocupado: true,
            inquilino: nil,
            notas: "Departamento amueblado",
            images: [],
            numeroRecamaras: 2,
            numeroBanos: 2,
            numeroEstacionamientos: 1,
            aceptaMascotas: true,
            dimensiones: Dimensiones(largo: 8.0, ancho: 10.0, alto: 2.5)
        )
        
        let inmueble2 = Inmueble(
            id: UUID(),
            type: .Casa,
            name: "Casa Norte",
            direccion: Direccion(
                id: UUID(),
                calle: "Insurgentes",
                numeroExterior: "456",
                numeroInterior: nil,
                colonia: "Del Valle",
                municipio: "Benito Juárez",
                estado: "CDMX",
                pais: "México",
                codigoPostal: "03100",
                apodo: "Norte",
                latitud: 19.3907,
                longitud: -99.1637
            ),
            metrosCuadrados: 120.0,
            rentaMensual: 25000.0,
            ocupado: true,
            inquilino: nil,
            notas: "Casa familiar",
            images: [],
            numeroRecamaras: 3,
            numeroBanos: 2,
            numeroEstacionamientos: 2,
            aceptaMascotas: false,
            dimensiones: Dimensiones(largo: 12.0, ancho: 10.0, alto: 3.0)
        )
        
        inmuebles = [inmueble1, inmueble2]
        
        let inquilino1 = Inquilino(
            firstName: "David",
            lastName: "Zárate",
            email: "david.zarate@email.com",
            phoneNumber: "555-123-4567"
        )
        
        let inquilino2 = Inquilino(
            firstName: "Valeria",
            lastName: "Vásquez",
            email: "valeria.vasquez@email.com",
            phoneNumber: "555-987-6543"
        )
        
        inquilinos = [inquilino1, inquilino2]
        
        let contrato1 = Contrato(
            departamentoID: inmueble1.id,
            inquilinoID: inquilino1.id,
            fechaInicio: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
            fechaFin: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date(),
            rentaMensual: 15000.0
        )
        
        let contrato2 = Contrato(
            departamentoID: inmueble2.id,
            inquilinoID: inquilino2.id,
            fechaInicio: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(),
            fechaFin: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date(),
            rentaMensual: 25000.0
        )
        
        contratos = [contrato1, contrato2]
        
        // Crear pagos de muestra
        pagos = [
            Pago(contratoID: contrato1.id, fechaPago: Calendar.current.date(byAdding: .month, value: -2, to: Date()) ?? Date(), monto: 15000.0, estado: .current, comprobante: "https://example.com/comprobante1.pdf"),
            Pago(contratoID: contrato1.id, fechaPago: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(), monto: 15000.0, estado: .current, comprobante: "https://example.com/comprobante2.pdf"),
            Pago(contratoID: contrato1.id, fechaPago: Date(), monto: 15000.0, estado: .upcoming),
            Pago(contratoID: contrato2.id, fechaPago: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(), monto: 25000.0, estado: .current, comprobante: "https://example.com/comprobante3.pdf"),
            Pago(contratoID: contrato2.id, fechaPago: Date(), monto: 25000.0, estado: .upcoming)
        ]
        
        // Crear gastos de muestra
        gastos = [
            Gasto(inmuebleID: inmueble1.id, tipo: .mantenimiento, monto: 2000.0, fecha: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(), descripcion: "Mantenimiento general"),
            Gasto(inmuebleID: inmueble1.id, tipo: .electricidad, monto: 800.0, fecha: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(), descripcion: "Recibo de luz"),
            Gasto(inmuebleID: inmueble2.id, tipo: .agua, monto: 500.0, fecha: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), descripcion: "Recibo de agua"),
            Gasto(tipo: .seguros, monto: 5000.0, fecha: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(), descripcion: "Seguro anual")
        ]
    }
    
    private func calcularResumenFinanciero() {
        let ingresos = pagos.filter { $0.estado == .current }.reduce(0) { $0 + $1.monto }
        let egresos = gastos.reduce(0) { $0 + $1.monto }
        let pendientes = pagos.filter { $0.estado == .upcoming }.reduce(0) { $0 + $1.monto }
        let vencidos = pagos.filter { $0.estado == .overdue }.reduce(0) { $0 + $1.monto }
        
        resumenFinanciero = ResumenFinanciero(
            ingresosTotales: ingresos,
            egresosTotales: egresos,
            balance: ingresos - egresos,
            pagosPendientes: pendientes,
            pagosVencidos: vencidos,
            periodo: "Enero 2025"
        )
    }
    
    private func generarEstadisticas() {
        // Estadísticas mensuales de muestra
        estadisticasMensuales = [
            EstadisticaMensual(mes: "Julio", año: 2024, ingresos: 40000, egresos: 8000, balance: 32000),
            EstadisticaMensual(mes: "Agosto", año: 2024, ingresos: 40000, egresos: 7500, balance: 32500),
            EstadisticaMensual(mes: "Septiembre", año: 2024, ingresos: 40000, egresos: 9000, balance: 31000),
            EstadisticaMensual(mes: "Octubre", año: 2024, ingresos: 40000, egresos: 8200, balance: 31800),
            EstadisticaMensual(mes: "Noviembre", año: 2024, ingresos: 40000, egresos: 7800, balance: 32200),
            EstadisticaMensual(mes: "Diciembre", año: 2024, ingresos: 40000, egresos: 8500, balance: 31500),
            EstadisticaMensual(mes: "Enero", año: 2025, ingresos: 40000, egresos: 8300, balance: 31700)
        ]
        
        // Estadísticas por inmueble
        estadisticasPorInmueble = inmuebles.map { inmueble in
            let ingresosInmueble = pagos.filter { pago in
                contratos.first { $0.id == pago.contratoID }?.departamentoID == inmueble.id
            }.reduce(0) { $0 + $1.monto }
            
            let egresosInmueble = gastos.filter { $0.inmuebleID == inmueble.id }.reduce(0) { $0 + $1.monto }
            
            return EstadisticaPorInmueble(
                inmuebleID: inmueble.id,
                nombreInmueble: inmueble.defaultName,
                ingresos: ingresosInmueble,
                egresos: egresosInmueble,
                balance: ingresosInmueble - egresosInmueble,
                porcentajeOcupacion: inmueble.ocupado ? 100.0 : 0.0
            )
        }
    }
    
    private func generarAlertas() {
        alertas = contratos.compactMap { contrato in
            guard let inquilino = inquilinos.first(where: { $0.id == contrato.inquilinoID }),
                  let inmueble = inmuebles.first(where: { $0.id == contrato.departamentoID }) else {
                return nil
            }
            
            let fechaVencimiento = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
            let diasRestantes = Calendar.current.dateComponents([.day], from: Date(), to: fechaVencimiento).day ?? 0
            
            let tipo: AlertaPago.TipoAlerta
            if diasRestantes < 0 {
                tipo = .vencido
            } else if diasRestantes <= 7 {
                tipo = .urgente
            } else {
                tipo = .proximo
            }
            
            return AlertaPago(
                contratoID: contrato.id,
                inquilinoID: inquilino.id,
                nombreInquilino: "\(inquilino.firstName) \(inquilino.lastName)",
                inmuebleID: inmueble.id,
                nombreInmueble: inmueble.defaultName,
                monto: contrato.rentaMensual,
                fechaVencimiento: fechaVencimiento,
                diasRestantes: diasRestantes,
                tipo: tipo
            )
        }
    }
    
    // MARK: - Filtros
    
    var pagosFiltrados: [Pago] {
        var filtrados = pagos
        
        // Filtrar por estado
        if let estado = filtroEstado {
            filtrados = filtrados.filter { $0.estado == estado }
        }
        
        // Filtrar por inquilino
        if !filtroInquilino.isEmpty {
            filtrados = filtrados.filter { pago in
                guard let contrato = contratos.first(where: { $0.id == pago.contratoID }),
                      let inquilino = inquilinos.first(where: { $0.id == contrato.inquilinoID }) else {
                    return false
                }
                let nombreCompleto = "\(inquilino.firstName) \(inquilino.lastName)"
                return nombreCompleto.localizedCaseInsensitiveContains(filtroInquilino)
            }
        }
        
        // Filtrar por fecha
        switch filtroFecha {
        case .todos:
            break
        case .esteMes:
            let inicioMes = Calendar.current.dateInterval(of: .month, for: Date())?.start ?? Date()
            filtrados = filtrados.filter { $0.fechaPago >= inicioMes }
        case .mesPasado:
            let mesPasado = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            let inicioMesPasado = Calendar.current.dateInterval(of: .month, for: mesPasado)?.start ?? Date()
            let finMesPasado = Calendar.current.dateInterval(of: .month, for: mesPasado)?.end ?? Date()
            filtrados = filtrados.filter { $0.fechaPago >= inicioMesPasado && $0.fechaPago < finMesPasado }
        case .ultimos3Meses:
            let tresMesesAtras = Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date()
            filtrados = filtrados.filter { $0.fechaPago >= tresMesesAtras }
        case .ultimos6Meses:
            let seisMesesAtras = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
            filtrados = filtrados.filter { $0.fechaPago >= seisMesesAtras }
        case .personalizado:
            filtrados = filtrados.filter { $0.fechaPago >= fechaInicio && $0.fechaPago <= fechaFin }
        }
        
        return filtrados.sorted { $0.fechaPago > $1.fechaPago }
    }
    
    // MARK: - Acciones
    
    func agregarPago(contratoID: UUID, monto: Double, fecha: Date, notas: String?, comprobante: String? = nil) {
        let nuevoPago = Pago(contratoID: contratoID, fechaPago: fecha, monto: monto, notas: notas, estado: .current, comprobante: comprobante)
        pagos.append(nuevoPago)
        calcularResumenFinanciero()
    }
    
    func agregarGasto(inmuebleID: UUID?, tipo: TipoGasto, monto: Double, fecha: Date, descripcion: String, comprobante: String?, notas: String?) {
        let nuevoGasto = Gasto(inmuebleID: inmuebleID, tipo: tipo, monto: monto, fecha: fecha, descripcion: descripcion, comprobante: comprobante, notas: notas)
        gastos.append(nuevoGasto)
        calcularResumenFinanciero()
    }
    
    func generarReporteMensual() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        let mesActual = formatter.string(from: Date())
        
        var reporte = "REPORTE FINANCIERO - \(mesActual)\n"
        reporte += "================================\n\n"
        
        reporte += "RESUMEN FINANCIERO:\n"
        reporte += "Ingresos Totales: $\(String(format: "%.2f", resumenFinanciero.ingresosTotales))\n"
        reporte += "Egresos Totales: $\(String(format: "%.2f", resumenFinanciero.egresosTotales))\n"
        reporte += "Balance: $\(String(format: "%.2f", resumenFinanciero.balance))\n"
        reporte += "Pagos Pendientes: $\(String(format: "%.2f", resumenFinanciero.pagosPendientes))\n"
        reporte += "Pagos Vencidos: $\(String(format: "%.2f", resumenFinanciero.pagosVencidos))\n\n"
        
        reporte += "PAGOS REALIZADOS:\n"
        for pago in pagosFiltrados {
            if let contrato = contratos.first(where: { $0.id == pago.contratoID }),
               let inquilino = inquilinos.first(where: { $0.id == contrato.inquilinoID }),
               let inmueble = inmuebles.first(where: { $0.id == contrato.departamentoID }) {
                reporte += "- \(inquilino.firstName) \(inquilino.lastName) (\(inmueble.defaultName)): $\(String(format: "%.2f", pago.monto))\n"
            }
        }
        
        reporte += "\nGASTOS:\n"
        for gasto in gastos {
            reporte += "- \(gasto.tipo.rawValue): $\(String(format: "%.2f", gasto.monto)) - \(gasto.descripcion)\n"
        }
        
        return reporte
    }
} 
