object casaDePepeYJulian {
	var viveres = 50
	var montoReparaciones = 0
	var cuentaParaGastos = cuentaCorriente
	var estrategia = minimoIndispensable
	
	method hayQueHacerReparaciones() {
		return montoReparaciones > 0
	}
	
	method cuentaParaGastos() {
		return cuentaParaGastos
	}
	
	method viveres() {
		return viveres
	}
	
	method montoReparaciones() {
		return montoReparaciones
	}
	
	method comprarViveres() {
		estrategia.comprarViveres()
	}
	
	method sumarViveres(porcentaje) {
		viveres += porcentaje
	}
	
	method pagarGasto(dinero) {
		cuentaParaGastos.extraer(dinero)
	}
	
	method romper(dinero) {
		montoReparaciones += dinero
	}
	
	method tieneViveresSuficientes() {
		return viveres > 40
	}
	
	method estaEnOrden() {
		return (not self.hayQueHacerReparaciones()) and self.tieneViveresSuficientes()
	}
	
	method cambiarEstrategia(_estrategia) {
		estrategia = _estrategia
	}
	
	method saldoDeCasa() {
		return cuentaParaGastos.saldo()
	}
	
	method nuevaCuentaParaGastos(cuenta) {
		cuentaParaGastos = cuenta
	}
}

object cuentaCorriente {
	var saldo = 0
	
	method depositar(dinero) {
		saldo += dinero
	} 
	
	method saldo() {
		return saldo
	}
	
	method extraer(dinero) {
		saldo -= dinero
	}

}

object cuentaConGasto {
	var saldo = 0
	var property costoDeOperacion = 0
	
	method depositar(dinero) {
		saldo += dinero - self.costoDeOperacion()
	} 
	
	method saldo() {
		return saldo
	}
	
	method extraer(dinero) {
		saldo -= dinero
	}

}

object cuentaCombinada {
	var cuentaPrimaria = cuentaCorriente
	var cuentaSecundaria = cuentaConGasto
	
	method depositar(dinero) {
		cuentaPrimaria.depositar(dinero)
	} 
	
	method saldo() {
		return cuentaPrimaria.saldo() + cuentaSecundaria.saldo()
	}
	
	method extraer(dinero) {
		if (cuentaPrimaria.saldo() > dinero) {
			cuentaPrimaria.extraer(dinero)
		} else {
			cuentaSecundaria.extraer(dinero)
		}
	
	}
	
	method cambiarCuentaPrimaria(cuenta) {
		cuentaPrimaria = cuenta
	}
	
	method cambiarCuentaSecundaria(cuenta) {
		cuentaSecundaria = cuenta
	}
	
	method cuentaPrimaria() {
		return cuentaPrimaria
	}
	
	method cuentaSecundaria() {
		return cuentaSecundaria
	}
	
	
	   
}

object minimoIndispensable {
	var calidad = 1 
	var porcentaje = 0
	var casa = casaDePepeYJulian
	var property porcentajeSiNoTieneViveresSuficientes = 40
	
	method comprarViveres() {
		self.porcentajeDeCasa()
		
		if(not self.tieneViveresSuficientesCasa()) {
			casa.sumarViveres(porcentajeSiNoTieneViveresSuficientes - porcentaje)
			casa.pagarGasto((porcentajeSiNoTieneViveresSuficientes  - porcentaje) * calidad)
		}
	}
	
	method cambiarCalidad(_calidad) {
		calidad = _calidad
	}
	
	method porcentajeDeCasa() {
		porcentaje = casa.viveres()
	}
	
	method tieneViveresSuficientesCasa() {
		return casa.tieneViveresSuficientes()
	}
	
	method casaNueva(_casa) {
		casa = _casa
	}
}

object full {
	const property calidad = 5
	var porcentaje = 0
	var casa = casaDePepeYJulian
	var property porcentajeViveresBase = 40
	var property porcentajeViveresSiEstaEnOrden = 100 
	
	method comprarViveres() {
		self.porcentajeDeCasa()
		
		if(self.estaEnOrdenCasa()) {
			casa.sumarViveres(porcentajeViveresSiEstaEnOrden - porcentaje)
			casa.pagarGasto((porcentajeViveresSiEstaEnOrden - porcentaje) * calidad)
		} else {
			casa.sumarViveres(porcentajeViveresBase)
			casa.pagarGasto(porcentajeViveresBase * calidad)
		}
		
		self.pagarReparaciones()
		
	}
	
	method pagarReparaciones() {
		const dineroQueSobrara = casa.montoReparaciones() - casa.saldoDeCasa()
		
		if(casa.montoReparaciones() < casa.saldoDeCasa() and dineroQueSobrara.abs() > 1000) {
			casa.pagarGasto(casa.montoReparaciones())
		}
	}
	
	method porcentajeDeCasa() {
		porcentaje = casa.viveres()
	}
	
	method estaEnOrdenCasa() {
		return casa.estaEnOrden()
	}
	
	method casaNueva(_casa) {
		casa = _casa
	}
}