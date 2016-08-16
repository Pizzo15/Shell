#!/bin/bash

# Richiedo il nome dell'aula di cui mostrare le prenotazioni
echo "Inserire aula:"
read aula

# Grep -c conta il n° di riferimenti nel primo campo di ogni riga dell'aula cercata: se questo è uguale a 0 non ci sono prenotazioni per aula 
if [ `grep -c '^'$aula';' aule.txt` -eq 0 ]
then
	echo "Errore: nessuna prenotazione per l'aula $aula"
else
	
	# Stampo il menù
	echo "---------------------------"
	echo "|PRENOTAZIONI AULA $aula  |"
	echo "---------------------------"
	echo "Giorno Ora Utente"
	echo

	# Scorro ogni riferimento ottenuto:
	# Grep seleziona solo le righe che iniziano per l'aula cercata
	# Cut mantiene solo i campi interessati per la stampa (data, ora, utente)
	# Sort ordina il risultato delle prime due operazioni prima in base alla data e all'orario numericamente
	for rif in `grep '^'$aula';' aule.txt | cut -f2-4 -d";" | sort -t";" -k1n,1 -k2n,2`
	do
		# Salvo i riferimenti in un file temporaneo
		echo $rif >> temp
		echo >> temp
	done
	
	# Sed sostituisce tutti i riferimenti a ";" con uno spazio nel file temp
	# Cat stampa il file ottenuto
	sed 's/;/ /g' temp | cat

	# Elimino il file temporaneo
	rm temp
fi