#!/bin/bash

mkdir -p ../reports

NEWMAN_PATH="../collections"
ENV_PATH="../environments"
REPORT_PATH="../reports"

for file in $NEWMAN_PATH/*.json; do
    COLLECTION_NAME=$(basename $file .json)
    echo "Running $COLLECTION_NAME..."
    
    newman run "$file" \
        -e "$ENV_PATH/staging.postman_environment.json" \
        --reporters cli,html,junit \
        --reporter-html-export "$REPORT_PATH/$COLLECTION_NAME.html" \
        --reporter-junit-export "$REPORT_PATH/$COLLECTION_NAME.xml"
done