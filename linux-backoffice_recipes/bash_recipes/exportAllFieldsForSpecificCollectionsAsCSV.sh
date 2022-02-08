temporalDBPath="/home/jailbirt/workspace/datadirMongoTradingTemp"
DB="tradingbot"
dockerName="mongo-temp"

mkdir $temporalDBPath;docker run --name $dockerName -v $temporalDBPath:/data/db -d mongo:4.2
docker exec -it $dockerName /bin/bash
#copiar al punto de montaje el dump
mongorestore --gzip --archive=/data/db/dump/tradingbot_db_backup.gz
#listar dbs,
docker exec $dockerName db.adminCommand( { listDatabases: 1 } )


collections="Instrument Order ArbitrageInstrument ArbitrageOperation"
for col in $collections; do
    echo "Exporting collection $col"
    # get comma separated list of keys. do this by peeking into the first document in the collection and get his set of keys
keys=$(docker exec $dockerName mongo tradingbot --quiet --eval "function z(c,e){if(c===null || c === undefined || c instanceof Date){return e};var a=[];var d=Object.keys(c);for(var f in d){var b=d[f];if(b != undefined && c != undefined && typeof c[b]==='object'){var g=[],h=z(c[b],e+'.'+b);a=g.concat(a,h);}else a.push(e+'.'+b);}return a;}var a=[],b=db['$col'].findOne({}),c=Object.keys(b);for(var i in c){var j=c[i];if(typeof b[j]==='object'&&j!='_id'){var t1=[],t2=z(b[j],j);a=t1.concat(a,t2);}else a.push(j);}a.join(',');")
    echo "keys:
         $keys
         end keys"
    # now use mongoexport with the set of keys to export the collection to csv
    docker exec $dockerName mongoexport --quiet -d $DB -c $col --fields "$keys" --type=csv --out "/data/db/$col.csv"
done
