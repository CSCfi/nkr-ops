#!/bin/bash

# A wrapper script to:
# 1. show the status of the index
# 2. run the 'harvest' and 'manage' commands
# 3. show the status of the index afterwards


DATASOURCE=$1

# Check that we have an argument and PHP interpreter
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


# Show the status of index and confirm
echo "Solr index before harvesting:"
curl http://localhost:8983/solr/biblio/query -d '{ "query" : "*", "fields" : "title, display_restriction_id_str, _document_id, id, datasource_str_mv", "limit" : "1" }'

read -p "Do you want to continue harvesting? (Y/n) " -r
if [[ "${REPLY}" =~ ^[Nn]$ ]]
then
    exit 0
fi

# Harvest and show the status of index afterwards
php harvest.php --source=${DATASOURCE} --verbose &&
echo -e "\n\n************      Updating Solr      ************" &&
php manage.php --func=updatesolr

if [ $? -ne 0 ]
then
    echo "Failed when trying to harvest the datasource"
    exit 1
fi

echo "Solr index after harvesting:"
curl http://localhost:8983/solr/biblio/query -d '{ "query" : "*", "fields" : "title, display_restriction_id_str, _document_id, id, datasource_str_mv", "filter" : ["!datasource_str_mv:local_ead"], "limit" : "1" }'
