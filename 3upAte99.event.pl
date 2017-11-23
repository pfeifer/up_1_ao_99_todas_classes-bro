automacro upAteLv12Aprendiz {
	ConfigKeyNot lockMap pay_fild01
	ConfigKeyNot In_saveMap_sequence true
	JobLevel != 10
	JobID 0
	exclusive 1
	timeout 30
	InMapRegex /^(?!new_\d-\d|moc_prydb1)$/
	call {
		log pelo visto, ainda to no lvl de Classe $JobLevelLast ainda...
		log o que aconteceu?
		log a que ponto chegamos?
		log nuss
		log Tentando resolver isso...
		
		call upar
	}
}

automacro UpClasse1 {
	JobID $IDClasse1 
	BaseLevel != 99
	ConfigKeyNot quest_eden em_curso
	ConfigKeyNot quest_eden terminando
	ConfigKeyNot In_saveMap_sequence true
	ConfikKeyNot virarClasse2 true
	ConfigKeyNot lockMap $mapa{lockMap}
	JobLevel != 50
	exclusive 1
	priority 20 #baixa prioridade
	timeout 30
    call upar
}

automacro upClasse2 {
	JobID $IDClasse2 #todas as classes 2
	BaseLevel != 99
	ConfigKeyNot quest_eden em_curso
	ConfigKeyNot quest_eden terminando
	ConfigKeyNot In_saveMap_sequence true
	ConfikKeyNot virarClasse2 true
	ConfigKeyNot lockMap $mapa{lockMap}
	exclusive 1
	priority 20 #baixa prioridade
	timeout 30
    call upar
}


macro upar {
	#código feito por vitorsilverio
	$i = 0
	while ($i < @mapasDeUp) { #vamos checar todos os mapas de up
		@configuracoesUp = &split(';', $mapasDeUp[$i])

		#ConfiguracoesUp array
		#0 - Nivel Mínimo
		#1 - Nivel Máximo
		#2 - lockMap
		#3 - saveMap
		if($.lvl >= $configuracoesUp[0] && $.lvl <= $configuracoesUp[1]){
			$mapa{lockMap} = $configuracoesUp[2]
			$mapa{city} = $configuracoesUp[3]
			$i = @mapasDeUp #gambiarra pra parar o loop assim que encontrar
	  	}
	  	$i++
  	}
	$i = undef
  	
	if (&config(lockMap) = $mapa{lockMap}) {
		[
		log ================================
		log =Tudo Configurado
		log =Continuarei upando em $mapa{lockMap}
		log ================================
		]
		call voltarAtacar
		stop
	}
	
	#se chegar aqui significa que tem que ser mudado o lockmap e/ou o saveMap
	if (&config(saveMap) = $mapa{city}) {
		do conf lockMap $mapa{lockMap}
		call voltarAtacar
	} else {
		call pararDeAtacar
		call SetSaveIn "$mapa{city}"
	}
}

automacro estouLv99 {
	BaseLevel = 99
	exclusive 1
	timeout 120
	JobID 17 #arruaceiro
	call {
		log CHEGUEI NO LVL 99 FINALMENTE !!!!!!!
		log CARA ISSO LEVOU TEMPO PARA CAR**HO
	}
}

automacro nivelDeClasse50 {
	JobLevel = 50
	JobID $IDClasse1 #todas as classes 1
	exclusive 1
	timeout 20
	NotInMap izlude
	ConfigKeyNot virandoClasse2 true
	call {
		log SEU CHAR JÁ ESTÁ NO NIVEL 50 DE CLASSE
		log FAÇA A QUEST PARA VIRAR CLASSE 2 MANUALMENTE POR FAVOR
		log DEPOIS ABRA O BOT NOVAMENTE
		log ASSIM QUE ELE SE TORNAR UM CLASSE 2, A MACRO VOLTA A UPAR NORMALMENTE
		do conf lockMap none
		call pararDeAtacar
	}
}

automacro nivelDeClasse50EmIzlude {
	InMap izlude
	exclusive 1
	timeout 20
	call {
		log SEU CHAR JÁ ESTÁ NO NIVEL 50 DE CLASSE
		log FAÇA A QUEST PARA VIRAR CLASSE 2 MANUALMENTE
		log DEPOIS ABRA O BOT NOVAMENTE
		log ASSIM QUE ELE SE TORNAR UM CLASSE 2, A MACRO VOLTA A UPAR NORMALMENTE
	}
}