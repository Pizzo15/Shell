#!/bin/bash

# Se il file non contiene prenotazioni stampo un messaggio di errore
if [ "`cat aule.txt`" = "" ]
then
	echo "Nessuna prenotazione registrata"
else
	# Per ogni aula nel file aule.txt, considerata una volta (uniq)
	for aula in `cut -f1 -d";" aule.txt | sort | uniq`
	do
		# Inserisco la stringa "<nome_aula>:<contatore_riferimenti>" in un file temporaneo
		# Grep -c conta il n° di riferimenti ad aula nel file
		echo "$aula:`grep -c "^$aula;" aule.txt`" >> count
	done

	echo "-------------------------"
	echo "| PRENOTAZIONI PER AULA |"
	echo "-------------------------"
	echo 
	# Stampo il file ordinato secondo il n° di prenotazioni una linea alla volta 
	for line in `sort -k2 -t":" count`
	do
		echo $line
		echo
	done
	
	# Elimino i file temporanei
	rm count
fi