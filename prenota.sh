#!/bin/bash

# Salvo nel formato previsto da input la data di oggi in una variabile
oggi=`date +%Y%m%d`

# Vettore che contiene i valori del numero di giorni per mese
v=(0 31 28 31 30 31 30 31 31 30 31 30 31)

# Funzione che controlla la validità della data inserita
# Riceve come parametro la data inserita
function formato_data {
	d=$1
	
	# Ricavo il giorno, il mese e l'anno dalla data inserita per i controlli
	# Nei mesi precedenti ottobre rimuovo lo 0 davanti alla cifra, altrimenti il n° verrebbe interpretato come ottale e dunque 08-09 non sarebbero consentiti
	a=`echo $d | cut -c1-4`
	m=`echo $d | cut -c5-6 | sed 's/^0//'`
	g=`echo $d | cut -c7-8`
	
	# Se l'anno della data in cui richiedo la prenotazione è bisestile febbraio ha 29 giorni
	# Controllo che il risultato delle espressioni % sia coerente con quelli attesi
	if [ `expr $a % 4` -eq 0 -a `expr $a % 100` -ne 0 ]
	then
		# Anno bisestile: Divisibile per 4 ma non centenario, non considero gli anni divisibili per 400: la finestra di compilazione è (2016-2029)
		v[2]=29
	else
		# Anno non bisestile
		v[2]=28
	fi
	 
	# Controllo che la data inserita sia un valore numerico
	if [ `echo $d | grep -c [^0-9]` -ne 0 ]
	then
		# Caso 1: La data inserita è una stringa
		echo "1"
	elif [ $oggi -gt $d ]
	then
		# Caso 2: La data inserita è passata
		echo "2"
	elif [ $d -gt 20291231 ]
	then
		# Caso 3: La data inserita è successiva al 31/12/2029
		echo "3"
	elif [ $m -gt 12 -o $m -lt 1 ]
	then
		# Caso 4: Inserimento mesi non corretto
		echo "4"
	elif [ $g -gt ${v[$m]} -o $g -lt 1 ]
	then
		# Caso 5: Inserimento giorni non corretto
		echo "5"
	else
		# Caso 0: La data è ok
		echo "0"
	fi
}

# Funzione che controlla che l'ora inserita sia nel formato richiesto
# Riceve come parametro l'ora inserita
function formato_ora {
	o=$1
	
	if [ `echo $o | grep -c [^0-9]` -ne 0 ]
	then
		# Caso 1: L'orario inserito non è un intero
		echo "1"
	elif [ $o -lt 8 -o $o -gt 17 ]
	then
		# Caso 2: Orario inserito non è nell'intervallo consentito
		echo "2"
	else
		# Caso 0: Orario corretto
		echo "0"
	fi
}

# Stampo il menù per la richiesta dei dati e leggo le variabili immesse
echo "----------------"
echo "| PRENOTAZIONE |"
echo "----------------"
echo "Nome Aula:"
read aula

echo "Data:"
read data
# Finchè la data inserita non è valida stampo un messaggio di errore e continuo a richiederla
while [ `formato_data $data` != "0" ]
do
	case `formato_data $data` in
		1) echo "La data deve essere un valore intero (aaaammgg)";;
		2) echo "Non posso effettuare prenotazioni per date passate";;
		3) echo "Non posso effettuare prenotazioni per date successive al 31/12/2029";;
		4) echo "Il mese deve essere un valore compreso tra 1 e 12";;
		5) echo "Giorno inesistente";;
		*) echo;;
	esac
	
	echo "Data:"
	read data
done

echo "Orario:"
read ora
# Continuo a richiedere l'orario finchè quello inserito non è valido
while [ `formato_ora $ora` != "0" ]
do
	case `formato_ora $ora` in
		1) echo "L'orario deve essere un intero";;
		2) echo "La finestra di prenotazione è 8-17";;
		*) echo;;
	esac

	echo "Orario:"
	read ora
done

# Conto il n° di linee in aule.txt che contengono il pattern "aula;data;ora", se questo è uguale a 0 l'aula non è già occupata
if [ `grep -c "$aula;$data;$ora" aule.txt` -gt 0 ]
then
	# Stampo errore
	echo "Errore: Aula $aula già prenotata"
else
	# Altrimenti richiedo il nome utente 
	echo "Nome Utente:"
	read utente

	# Inserisco i valori nel file e stampo un messaggio di conferma
	echo "$aula;$data;$ora;$utente" >> aule.txt
	echo
	echo "Inserimento dei dati riuscito"	
fi