#!/bin/ksh
################################################################################
#@(#) Naam:      parse_config.sh
#@(#) Functie:   leest de configuratie voor een bepaalde interface 
#@(#) Datum:     10 february 2010
#@(#) Auteur:    Ronald de Gunst
#@(#) $Revision: 1540 $
#@(#) $Date: 2011-04-06 13:17:36 +0200 (wo, 06 apr 2011) $
#@(#) Modified: 
################################################################################
# SCRIPTS ONDERHOUDEN OP ROOD EN DAARNA DISTRIBUEREN. NIET DECENTRAAL AANPASSEN
################################################################################

###
# Init
###

export IHOME=/interface
export INTF=${IHOME}
export THISHOST=`hostname`
export L_APPLA=${1}
export L_DIR=${2}
export L_APPLB=${3}

parse_vars() {
  OIFS=${IFS}
  IFS=":
"
  set -- `grep "^${L_APPLA}:${L_DIR}:${L_APPLB}:.*:${THISHOST}:$" ${IHOME}/etc/config`
  IFS=$OIFS
  export L_WORK=${IHOME}/${L_APPLA}/${L_DIR}/${L_APPLB}/work
  export L_SAVE=${IHOME}/${L_APPLA}/${L_DIR}/${L_APPLB}/save
  export L_DONE=${IHOME}/${L_APPLA}/${L_DIR}/${L_APPLB}/done
  export L_ERROR=${IHOME}/${L_APPLA}/${L_DIR}/${L_APPLB}/error
  export L_LOG=${IHOME}/${L_APPLA}/${L_DIR}/${L_APPLB}/log
  export L_BIN=${IHOME}/${L_APPLA}/${L_DIR}/${L_APPLB}/bin
  export LOGFILE=${L_LOG}/interface_log
  export INTERLOG=${ILOG}/interfaced_log 
  export PROXY=${4}
  export REMOTE_HOST=${5}
  export PROTOCOL=${6}
  export USER_NAME=${7}
  export PASSWORD=${8}
  export L_TRANS=${9}
  export L_INVAL=${10}
  export L_INVAL1=${11:-600}
  export L_INBOX=${12:-${IHOME}/${L_APPLA}/${L_DIR}/${L_APPLB}/inbox}
  export L_DUMP=${13}
  export L_OUTBOX=${14:-${IHOME}/${L_APPLA}/${L_DIR}/${L_APPLB}/outbox}
  export L_INEXT=${15}
  export L_OKEXT=${16}
  export L_OPTIES=${17}
  export L_MONITOR=${23}
  [ $L_MONITOR ] || export L_MONITOR=${19}
  export L_MONITOR_NORUN=${24}
  [ $L_MONITOR_NORUN ] || export L_MONITOR_NORUN=${20}

  if [ "${PROXY}" = "to_proxy" ]
  then
    export PROXY_INBOX=${IHOME}/${L_APPLA}/to/${L_APPLB}/inbox
  fi

  # Default aflever inbox is $APPLB/from/$APPLA/inbox. Moet er op een andere
  # locatie worden afgeleverd dan is inbox: kolom 12 van $APPLB:from:$APPLA 
  # regel in $IHOME/etc/config voor de betreffende bestemmingshost 
  export INBOX_FROM_CONFIG=`grep "^${L_APPLB}:from:${L_APPLA}:[^:]*:${THISHOST}:" $IHOME/etc/config | cut -f12 -d:`
  # Val terug naar de PROXY_INBOX indien geen INBOX_FROM_CONFIG
  export REMOTE_INBOX=${INBOX_FROM_CONFIG:-${PROXY_INBOX}}
  # Val terug naar standaard inbox indien niet gedefinieerd.
  export REMOTE_INBOX=${REMOTE_INBOX:-${IHOME}/${L_APPLB}/from/${L_APPLA}/inbox}

  export FLAG_FILE=`grep "^${L_APPLB}:from:${L_APPLA}:[^:]*:${THISHOST}:" ${IHOME}/etc/config | cut -f22 -d:`
}

display() {
  echo "
  Details voor de interface: ${L_APPLA} ${L_DIR} ${L_APPLB} op server: ${THISHOST}
  ---------------------------------------------------------
  Inbox directory          => ${L_INBOX}
  Outbox directory         => ${L_OUTBOX}
  Werk directory           => ${L_WORK}
  Save directory           => ${L_SAVE}
  Done directory           => ${L_DONE}
  Error directory          => ${L_ERROR}
  Log directory            => ${L_LOG}
  Bin directory            => ${L_BIN}
  Log bestand              => ${LOGFILE}
  Ontvangende server       => ${REMOTE_HOST}
  Proxy inbox directory    => ${PROXY_INBOX:-nvt}
  Remote inbox directory   => ${REMOTE_INBOX}
  Verzend methode          => ${PROTOCOL:-cp}
  Interval voor interfaced => ${L_INVAL}
  Interval voor delivery   => ${L_INVAL1}
  Over te zetten bestanden => *${L_INEXT}
  Monitoring               => ${L_MONITOR}
  Monitor norun.lck        => ${L_MONITOR_NORUN}
  "
}

###
# main
###

# Zet de variabelen.
parse_vars
# Als parameter $4 gelijk is aan '-h', toon de configuratie voor de interface.
[ "$4" = "-h" ] && display