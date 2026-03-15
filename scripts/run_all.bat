@echo off
REM -------------------------------
REM Run Postman Collections with Newman
REM -------------------------------

REM Get the first argument as environment file
SET ENV_FILE=%1

REM Check if environment file is provided
IF "%ENV_FILE%"=="" (
    ECHO No environment file provided. Using QA as default.
    SET ENV_FILE=environments\QA.postman_environment.json
)

REM Create reports folder if it doesn't exist
IF NOT EXIST reports (
    mkdir reports
)

REM Run Newman with HTML reporter
newman run collections\LibraryCollections.postman_collection.json ^
    -e %ENV_FILE% ^
    -r html ^
    --reporter-html-export reports\report.html

REM Notify completion
ECHO Newman run completed. Report saved in reports\report.html
pause