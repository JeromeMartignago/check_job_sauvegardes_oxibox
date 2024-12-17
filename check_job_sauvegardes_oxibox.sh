#! /bin/bash

# Plugin return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

OK="0"
WARNING="1"
CRITICAL="2"

print_version() {
  echo $SCRIPTNAME version $VERSION
  echo ""
  echo "Ce plugin est fourni avec ABSOLUTELY NO WARRANTY."
  echo "You may redistribute copies of the plugins under the terms of the GNU General Public License v2."
  echo "Vous devez redistribuer des copies de ce plugin sous les termes de la GNU General Public License v2."

}

# Option processing
print_usage() {
  echo "Usage: ./check_job_sauvegarde_oxibox -M Nom_de_la_tache -C Nom_de_la_collectivite -F Fichier_Rapports.csv -w 2.7 -c 3"
  echo "  $SCRIPTNAME -M NOM-MACHINE"
  echo "  $SCRIPTNAME -C COLLECTIVITE"
  echo "  $SCRIPTNAME -F FICHIER"
  echo "  $SCRIPTNAME -w WARNING"
  echo "  $SCRIPTNAME -c CRITIQUE"
  echo "  $SCRIPTNAME -h"
  echo "  $SCRIPTNAME -V"
}

print_help() {
  print_version
  echo ""
  print_usage
  echo ""
  echo "Vérifie le nombre de job réussi sur le nombre total de job sur une machine"
  echo ""
  echo "-M Machine à Vérifier"
  echo "   Nom de la Machine à vérifier"
  echo "-C Collectivite"
  echo "   Nom de la collectivité à vérifier"
  echo "-F Fichier qui contient les Rapports"
  echo "   Le fichier qui contient le résultat dus sauvegardes"
  echo "-w INTEGER"
  echo "   Valeur d'alerte pour ce Job (default: 0)"
  echo "-c INTEGER"
  echo "   Valeur Max prévue dans la convention (default: 0)"
  echo "-h"
  echo "   Affiche cette aide"
  echo "-V"
  echo "   Affiche la version et la licence"
  echo ""
  echo ""
  echo "Ce plugin vérifie le nombre de sauvegardes d'une machine dans un fichier de rapport de sauvegarde."
  echo "Ce plugin produit des données de performance pour des graphes."
  echo "Si la valeur de la taille de la sauvegarde et/ou le temps sont nuls alors le scipt retourne un état à ERREUR "
  echo "If the warning level and critical levels are both set to 0, then the script returns OK state."
}

while getopts M:F:C:w:c:h:V OPT
do
  case $OPT in
    M) MAC="$OPTARG" ;;
    F) FICHIER="$OPTARG" ;;
    C) COLLECTIVITE="$OPTARG" ;;
    w) WARNING=$OPTARG ;;
    c) CRITICAL=$OPTARG ;;
    h)
      print_help
      exit $STATE_UNKNOWN
      ;;
    V)
      print_version
      exit $STATE_UNKNOWN
      ;;
   esac
done

JOB_OK=$(cat $FICHIER | grep -w -i $COLLECTIVITE | grep -w -i $MAC | cut -d',' -f6)
JOB_NOK=$(cat $FICHIER | grep -w -i $COLLECTIVITE | grep -w -i $MAC | cut -d',' -f7)
HOTE=$(cat $FICHIER | grep -w -i $COLLECTIVITE | grep -w -i $MAC | cut -d',' -f5)


jour_sauv=$(cat $FICHIER | grep -w -i $COLLECTIVITE | grep -w -i $MAC |cut -d',' -f1)

if [[ "$JOB_OK" -eq "$JOB_NOK" ]]
then
       STATE=$STATE_OK
else STATE=$STATE_CRITICAL
fi

DESCRIPTION="Sur $HOTE,NB sauvegardes OK : $JOB_OK et NB sauvegardes : $JOB_NOK Le : $jour_sauv | O$OK;W$WARNING;C$CRITICAL;"
echo $DESCRIPTION $STATE
exit $STATE
