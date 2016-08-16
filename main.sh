#!/bin/bash

# Creo il file aule.txt
touch aule.txt

PRENOTA=../Bash/prenota.sh
ELIMINA=../Bash/elimina.sh
MOSTRA=../Bash/mostra.sh
PRENOTAZIONI=../Bash/prenotazioni.sh

# funzione per la stampa del menù interattivo
stampa_menu(){
	echo "------------------------"
	echo "| SISTEMA GESTIONE AULE |"
	echo "------------------------"
	echo "1. Prenota"; echo
	echo "2. Elimina prenotazione"; echo
	echo "3. Mostra aula"; echo
	echo "4. Prenotazioni per aula"; echo
	echo "5. Esci";
}

# eseguo un ciclo di stampa del menù finchè non voglio uscire (premo tasto 5)
while [ "$c" != "5" ]
do
	stampa_menu
	read c
	
	case $c in
		1) bash $PRENOTA;;
		2) bash $ELIMINA;;
		3) bash $MOSTRA;;
		4) bash $PRENOTAZIONI;;
		5) exit;;
		*) echo "Errore: selezione non valida!";;
	esac
done