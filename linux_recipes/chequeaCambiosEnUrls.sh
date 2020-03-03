#!/bin/bash

#question issue
#https://www.procuraduria.gov.co/CertWEB/Certificado.aspx?tpo=1

#pdf metadata issue, timeouts, redirects
#https://scsanctions.un.org/fop/fop?xml=htdocs/resources/xml/en/consolidated.xml&xslt=htdocs/resources/xsl/en/consolidated.xsl

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
getCmd="lynx"
tmpFile="/tmp/site.tmp"
stateFile="/tmp/urls_monitor.state"
urls="https://antecedentes.policia.gov.co:7005/WebJudicial/index.xhtml
https://cfiscal.contraloria.gov.co/SiborWeb/Certificados/CertificadoPersonaNatural.aspx
https://www.treasury.gov/ofac/downloads/sdnlist.pdf
http://hmt-sanctions.s3.amazonaws.com/sanctionsconlist.pdf
https://www.deadiversion.usdoj.gov
https://www.fbi.gov/wanted/fugitives
https://www.iadb.org/es/temas/transparencia/integridad-en-el-grupo-bid/empresas-y-personas-sancionadas,1293.html
https://www.interpol.int/en/How-we-work/Notices/View-Red-Notices
http://www.worldbank.org/en/projects-operations/procurement/debarred-firms
https://www.bankofengland.co.uk"
state="normal"
changedList=""

dpkg -l ${getCmd} &> /dev/null

if [ $? -ne 0 ]
then
  echo "Installing ${getCmd}..."
  apt-get update -qqq ; apt-get install -y ${getCmd}
  ${getCmd} --version
fi

updateIndicator() {

local url=$1

supervisor='https://supervisor.theeye.io'
accessToken='' # Integration token.
customer=''    # Customer.
indTitle="Site changed: ${url}"
readOnly='false'
indMessage="Date: $(date +%Y-%m-%d_%X%z)"

  indEncodedTitle=$(python -c "import urllib; print urllib.quote('''${indTitle}''')")
  indUrl="${supervisor}/indicator/title/${indEncodedTitle}?access_token=${accessToken}&customer=${customer}"

  resp=$(curl -s -o /dev/null -w %{http_code} -m 10 -X GET "${indUrl}")
  if [ $resp == 200 ];then
    echo "Indicator found, updating"
    method='PATCH'
  else
    echo "Indicator not found, creating a new one"
    method='POST'
    indUrl="${supervisor}/indicator?access_token=${accessToken}&customer=${customer}"
  fi

  status=$(curl -w %{http_code} -s -o /dev/null -m 10 -X ${method} ${indUrl} --header 'Content-Type: application/json' --data "{\"title\":\"$indTitle\",\"read_only\":\"${readOnly}\",\"state\":\"${state}\",\"type\":\"text\",\"value\":\"${indMessage}\"}")

  if [ ${status} -ne 200 ];then echo "failed to update indicator. status: ${status}" ; fi
}

if [ ! -s ${stateFile} ]
then

  echo "State file empty. Creating file: ${stateFile} ..."
  for url in ${urls}
  do
    echo "testing: ${url}"
    #wget -t 1 -T 10 -O ${tmpFile} "${url}" &> /dev/null
    lynx -dump -nolist "${url}" > ${tmpFile}
    status=$?
    hash=$(cat ${tmpFile} | md5sum | awk '{print $1}')
    echo "${url}|${hash}|${status}" >> ${stateFile}
  done

else

  lastCheck=$(cat ${stateFile})
  truncate --size 0 ${stateFile}

  echo "Last check "${lastCheck}""

  for url in ${urls}
  do
    #echo -e "\ntesting url: "${url}""
    shortUrl=$(echo "${url}" | cut -d'/' -f3)
    #wget -t 1 -T 10 -O ${tmpFile} "${url}" &> /dev/null
    lynx -dump -nolist "${url}" > ${tmpFile}
    status=$?

    #catch network errors
    if [ $status -ne 0 ];then
      echo "error. skipping check. ${cmdGet} for ${url} failed status: ${status}"
      echo "${url}|${oldHash}|${status}" >> ${stateFile}
      continue
    fi
      
    hash=$(cat ${tmpFile} | md5sum | awk '{print $1}')
    oldHash=$(echo "${lastCheck}" | grep "${url}" | cut -d'|' -f2)
    if [ "${hash}" != "${oldHash}" ]
    then
      echo "check failed. hash:${hash} differs from oldHash:${oldHash}"
      state="failure"
      changedList+="${shortUrl} "
    #else
    #  echo "check ok. hash:${hash} equals to oldHash:${oldHash}"
    fi
    echo "${url}|${hash}|${status}" >> ${stateFile}
  done

fi

if [ ${state} == "failure" ]
then
  echo "Changes found. Updating indicator ..."
  echo "Changed urls: ${changedList}" 
  for url in ${changedList}
  do
    updateIndicator $url
  done
  echo "${state}"
  exit 1
else
  echo "${state}"
  exit 0
fi
