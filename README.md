# check_job_sauvegardes_oxibox
sonde zabbix pour analyse des sauvegardes oxibox à partir du fichier créé avec script convertion_mail_oxibox

check_job_sauvegardes_oxibox_num.sh permet d’avoir un chiffre comme retour
  - 0 c’est ok
  - 1 c’est un warning (pas exploité encore)
  - 2 c’est une erreur

check_job_sauvegardes_oxibox.sh permet d’avoir un texte explicatif sur la completion des sauvegardes

Les 2 scripts sont à déployer dans le dossier externalscripts de Zabbix (en principe /usr/lib/zabbix/externalscripts/)
Le fichier à analyser doit aussi être dans ce dossier.

Dans Zabbix il faut ensuite faire la configuration : 
  - 
