#!/bin/bash	

# Stampo l'intestazione e richiedo l'immissione dei dati per l'eliminazione della prenotazione
echo "------------------------"
echo "| ELIMINA PRENOTAZIONE |"
echo "------------------------"
echo "Inserire il nome dell'aula:"
read aula
# Se non è presente nessuna aula con il nome richiesto nel file stampo un messaggio di errore e termino
if [ `grep -c "^$aula;" aule.txt` -eq 0 ]
then
	echo "Errore: Nessuna prenotazione per l'aula $aula"
else
	# Altrimenti richiedo la data e l'ora
	echo "Inserire la data:"
	read data
	echo "Inserire l'orario:"
	read ora
	
	# Grep -c conta il n° di riferimenti al pattern cercato nel file aule.txt, se questo è maggiore di 0 significa che la prenotazione richiesta esiste nel file
	if [ `grep -c "$aula;$data;$ora" aule.txt` -gt 0 ]
	then
		# Salvo il n° di linea del file contenente il riferimento in una variabile
		# Cut tiene il primo campo della grep <num_linea>:$aula;$data;$ora
		n=`grep -n "$aula;$data;$ora" aule.txt | cut -f1 -d":"`
	
		# Elimino la riga del file contenente il riferimento richiesto
		# -i modifica il file originale
		# '' ignoro i backup
		# '*d' elimina la linea * dal file
		sed  -i '' ''$n'd' aule.txt
		echo "Operazione terminata con successo!"
	else
		# Altrimenti stampo un messaggio di errore
		echo "Errore: prenotazione inesistente"
	fi
fi