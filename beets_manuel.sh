#!/bin/bash
############################################################################## 
#                                                                            #
#	SHELL: !/bin/bash       version 2                                      #
#									                                         #
#	NOM: u2pitchjami						                                 #
#									                                         #
#	            							                                 #
#									                                         #
#	DATE: 21/11/2024	           				                             #
#								                                    	     #
#	BUT: intégration manuelle des rejets Beets      #
#									                                         #
############################################################################## 

#définition des variables
source /home/pipo/bin/beets_manuel/.config.cfg
if [ -d TEMP ]; then
    rm -r TEMP
fi
if [ ! -d $DIRSAV_BEETS ]; then
	mkdir $DIRSAV_BEETS
fi
if [ ! -d $DOSLOG ]; then
    mkdir $DOSLOG
fi
echo -e "Sauvegarde de la base beets" | tee -a "${LOG}"
tar -czf ${DIRSAV_BEETS}${BACKUP_BEETS}.tar.gz ${BASE_BEETS}
echo -e "Sauvegarde compressée: \e[32m${BACKUP_BEETS}.tar.gz\e[0m\n" | tee -a "${LOG}"
echo -e "sauvegarde réalisée" | tee -a "${LOG}"

$BEETS_ENV
int_manuelle() {

echo -e "Modification du fichier de conf" | tee -a "${LOG}"
#echo "${CONFIG_MANUEL}"
if [ -f "${CONFIG_MANUEL}" ]; then
    mv "${CONFIG}" "${CONFIG_NORMAL}"
    mv "${CONFIG_MANUEL}" "${CONFIG}"
fi

echo "[`date`] - Let's go" | tee -a $LOG

cat "${BEETSMANUEL}" > TEMP
sort TEMP | uniq > "${BEETSMANUEL}"

#######################TRAITEMENT BEETS###################################
echo -e "[`date`] - Récupération du fichier recap manuel Beets :" | tee -a $LOG
NBBEETSMANUEL=$(cat "${BEETSMANUEL}" | wc -l)
echo -e "$NBBEETSMANUEL lignes à traiter manuellement" | tee -a $LOG
sleep 5
echo -e "[`date`] - Démarrage :" | tee -a $LOG
for ((b=1 ;b<=$NBBEETSMANUEL ;b++))
do
LIGNE=$(cat "${BEETSMANUEL}" | head -1 | tail +1)
NOMLIGNE=$(echo "${LIGNE}" | cut -d "/" -f 6,7 )
echo "Albums : ${NOMLIGNE} "| tee -a $LOG

beet import --noincremental "${LIGNE}"

if [[ $? -eq "0" ]]; then
    echo -e "Traitement OK, ligne suivante" | tee -a "${LOG}"
    sed -i '1d' "${BEETSMANUEL}"
else
    echo -e "Anomalies !!!" | tee -a "${LOG}"
    sed -i '1d' "${BEETSMANUEL}"
fi


done
echo -e "Modification du fichier de conf" | tee -a "${LOG}"
if [ -f $CONFIG_NORMAL ]; then
    mv "${CONFIG}" "${CONFIG_MANUEL}"
    mv "${CONFIG_NORMAL}" "${CONFIG}"
fi
echo "[`date`] - Voilà c'est fini, bisous" | tee -a $LOG

rm TEMP
}
modif_mode() {
if [ -f "${CONFIG_MANUEL}" ]; then
    mv "${CONFIG}" "${CONFIG_NORMAL}"
    mv "${CONFIG_MANUEL}" "${CONFIG}"
    MODE="manuel"
else
    mv "${CONFIG}" "${CONFIG_MANUEL}"
    mv "${CONFIG_NORMAL}" "${CONFIG}"
    MODE="normal"
fi

echo -e "${BOLD}Mode ${MODE} activé ${NC}"  | tee -a $LOG
sleep 3

menu
}

update() {
echo -e "${SAISPAS}${BOLD}Démarrage de la mise à jour de la base${NC}"

beet update

echo -e "${BOLD}Update terminée ${NC}"  | tee -a $LOG
sleep 3

menu
}

import_auto() {
echo -e "${SAISPAS}${BOLD}Démarrage de l'importation auto de la base ${NC}"

if [ -f $CONFIG_NORMAL ]; then
    mv "${CONFIG}" "${CONFIG_MANUEL}"
    mv "${CONFIG_NORMAL}" "${CONFIG}"
fi

beet import "${BASE}"

echo -e "${BOLD}importation auto terminée ${NC}"  | tee -a $LOG
sleep 3
echo -e "[`date`] - Extraction Beets des albums à importer manuellement :" | tee -a $LOG
grep "^skip" /home/pipo/bin/logs/beets/beet.log | cut -c6- >> /home/pipo/bin/recap_music/beets_manuel.txt
echo "" > /home/pipo/bin/logs/beets/beet.log
echo -e "Fichier disponible dans le dossier recap_music :" | tee -a $LOG

menu
}

move() {
echo -e "${SAISPAS}${BOLD}Démarrage du déplacements des fichiers mal placés ${NC}"

if [ -f $CONFIG_NORMAL ]; then
    mv "${CONFIG}" "${CONFIG_MANUEL}"
    mv "${CONFIG_NORMAL}" "${CONFIG}"
fi

beet move

echo -e "${BOLD}déplacements terminés ${NC}"  | tee -a $LOG
sleep 3

menu
}

menu() {

NBBEETSMANUEL=$(cat "${BEETSMANUEL}" | wc -l)
if [ -f "${CONFIG_MANUEL}" ]; then
    CHANGE_MODE="manuel"
else
    CHANGE_MODE="normal"
fi

echo -e "${SAISPAS}${BOLD}Que souhaites tu faire ?${NC}"
echo "1) - Traiter les intégrations manuelles ("${NBBEETSMANUEL}" en attente)"
echo "2) - Passer en mode : "${CHANGE_MODE}""
echo "3) - Réaliser une update de la base"
echo "4) - Réaliser une intégration automatique"
echo "5) - Mouvementer les fichiers de la base"
echo "6) - Quitter"
read MENU

case $MENU in

1)
    int_manuelle
    ;;
2)
    modif_mode
    ;;
3)
    update
    ;;
4)
    import_auto
    ;;
5)
    move
    ;;
6)
    quitter
    ;;
esac
}

quitter() {
echo "c'est fini bisous" | tee -a "${LOGS}"
}

menu
