#!/bin/bash
#Chequea web, permite diferencial dC-as hC!biles de fines de semana y feriados (solo argentina)
url=$1
regex=$2
## Optional ##
onlyWorkable="${3:-no}" #En yes, solo alerta los dC-as hC!biles.
proxy="${4:-}"
export http_proxy=$proxy
export https_proxy=$http_proxy
##
alert="yes"
## horario laboral
hasta=20
desde=8

#Return if today is a workable day.
function isWorkable () 
{
 timeZone="America/Buenos_Aires "
 day=$(env TZ="$timeZone" date '+%d')
 month=$(env TZ="$timeZone" date '+%m')
 year=$(env TZ="$timeZone" date '+%Y')
 hour=$(env TZ="$timeZone" date '+%H')
 dayOfWeek=$(env TZ="$timeZone" date '+%u')

day=18
month=4
 rm /tmp/feriados$year
 if [ ! -f /tmp/feriados$year ];then
  curl --silent --insecure --max-time 5 -X GET "http://nolaborables.com.ar/api/v2/feriados/2019?incluir=opcional"  > /tmp/feriados$year
 fi
 if cat /tmp/feriados$year |jq ".[] | select((.dia==$day and .mes==$month) and (.religion==\"cristianismo\" or .tipo==\"inamovible\"))"|grep motivo > /dev/null ;then
    echo "Motivo:feriado"
    alert="no"
 elif ((dayOfWeek > 5));then
    echo "Motivo:finde de semana"
    alert="no"
 elif ((hour > hasta)) || ((hour < desde));then 
    echo "Motivo:fuera de hora"
    alert="no"
 else 
    echo "Motivo:Laboral"
    alert="yes"
 fi
}

if [ "$onlyWorkable" == "yes" ]; then
 #isWorkable $day $month $dayOfWeek 
 echo "solo Alerta dC-as hC!biles"
 isWorkable
fi

if [ -z "$url" ] || [ -z "$regex" ];then
 echo please run "$0" url regex
 exit
fi


result=$(curl -L --silent --max-time 5 --insecure "$url" | grep "$regex") 
#echo "https_proxy=$proxy curl --silent --max-time 5 --insecure \"$url\" | grep \"$regex\" "
status="SUCCESS"
if [ "$result" == "" ] && [ "$alert" == "yes" ];then
 status="FAILURE"
fi
echo $status
