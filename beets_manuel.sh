#!/bin/bash
############################################################################## 
#                                                                            #
#	SHELL: !/bin/bash       version 1                                      #
#									                                         #
#	NOM: u2pitchjami						                                 #
#									                                         #
#	            							                                 #
#									                                         #
#	DATE: 17/11/2024	           				                             #
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

echo -e "Modification du fichier de conf" | tee -a "${LOG}"
if [ -f $CONFIG_MANUEL ]; then
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

beet import -C --noincremental "${LIGNE}"

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