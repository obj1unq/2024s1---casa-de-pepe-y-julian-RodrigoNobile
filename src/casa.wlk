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
	
	method mantener() {
		estrategia.mantener(self)
	}
	
	method reparar() {
		self.pagarGasto(self.montoReparaciones())
	}
	
	method comprarViveres(porcentaje, dinero) {
		viveres += porcentaje
		self.pagarGasto(dinero)
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
	var calidad = 0
	var property porcentajeSiNoTieneViveresSuficientes = 40
	
	method mantener(casa) {
		if(not casa.tieneViveresSuficientes()) {
			casa.comprarViveres(self.porcentajeAComprar(casa), self.porcentajeAComprar(casa) * calidad)
		}
	}
	
	method porcentajeAComprar(casa) {
		return porcentajeSiNoTieneViveresSuficientes - casa.viveres()
	}
	
	method cambiarCalidad(_calidad) {
		calidad = _calidad
	}
}

object full {
	const property calidad = 5
	var property porcentajeViveresBase = 40
	var property porcentajeViveresSiEstaEnOrden = 100 
	
	
	method mantener(casa) {
		const dineroQueSobrara = casa.montoReparaciones() - casa.saldoDeCasa()
		
		if(casa.estaEnOrden()) {
			casa.comprarViveres(self.porcentajeAComprar(casa), 
				 self.porcentajeAComprar(casa) * calidad)
		} else {
			casa.comprarViveres(porcentajeViveresBase, porcentajeViveresBase * calidad)
		}
		
		if(casa.montoReparaciones() < casa.saldoDeCasa() and dineroQueSobrara.abs() > 1000) {
			casa.reparar()
		}
	}
	
	method porcentajeAComprar(casa) {
		return porcentajeViveresSiEstaEnOrden - casa.viveres()
	}
}