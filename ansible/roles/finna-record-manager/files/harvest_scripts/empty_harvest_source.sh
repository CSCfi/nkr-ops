#!/usr/bin/env bash

DATASOURCE=$1
if [ $# -lt 1 ]
then
  echo "Please provide the data source name:"
  echo "$0 <datasource>"
  exit 1
fi

if ! which php 2> /dev/null 1>&2
then
    echo "PHP interpreter not found. Please enable with: \"scl enable rh-php73 bash\"."
    exit 1
fi

echo "Solr index before emptying:"
# TODO: show only "numFound":
curl http://localhost:8983/solr/biblio/query -d '{ "query" : "*", "fields" : "title, display_restriction_id_str, _document_id, id, datasource_str_mv", "limit" : "1" }'

php manage.php --func=markdeleted --source=${DATASOURCE} &&
php manage.php --func=deduplicate &&
php manage.php --func=updatesolr &&
php manage.php --func=deletesource --source=${DATASOURCE} --force

if [ $? -ne 0 ]
then
    echo "Failed when trying to empty the datasource"
    exit 1
fi

echo "Please check whether Solr index was also emptied:"
curl http://localhost:8983/solr/biblio/query -d '{ "query" : "*", "fields" : "title, display_restriction_id_str, _document_id, id, datasource_str_mv", "limit" : "1" }'

read -p "Do you want to _force empty_? (y/N) " -r

if [[ "${REPLY}" =~ ^[Yy]$ ]]
then
    echo "Emptying the old way..."
    php manage.php --func=deletesource --source=${DATASOURCE} --verbose &&
    php manage.php --func=deletesolr --source=${DATASOURCE} --force --verbose
    if [ $? -ne 0 ]
    then
        echo "Failed when trying to empty the datasource"
        exit 1
    fi
    echo "Please check whether Solr index was also emptied:"
    curl http://localhost:8983/solr/biblio/query -d '{ "query" : "*", "fields" : "title, display_restriction_id_str, _document_id, id, datasource_str_mv", "limit" : "1" }'
fi
