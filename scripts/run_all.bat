@echo off
REM ================================
REM Batch script to run Newman collections
REM ================================

SET ENV_FILE=%1
SET RUN_OPTION=%2
SET SPECIFIC_COLLECTION=%3
SET TEST_DATA_FILE=%4

echo =====================================
echo ENV_FILE: %ENV_FILE%
echo RUN_OPTION: %RUN_OPTION%
echo SPECIFIC_COLLECTION: %SPECIFIC_COLLECTION%
echo TEST_DATA_FILE: %TEST_DATA_FILE%
echo =====================================

REM Run Newman with htmlextra reporter
REM Output HTML report into ./reports folder with timestamp

SET REPORTS_DIR=reports
IF NOT EXIST %REPORTS_DIR% (
    mkdir %REPORTS_DIR%
)

SET TIMESTAMP=%DATE:~-4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
SET TIMESTAMP=%TIMESTAMP: =0%

IF "%RUN_OPTION%"=="Specific" (
    newman run collections/%SPECIFIC_COLLECTION%.postman_collection.json -e %ENV_FILE% -r htmlextra --reporter-htmlextra-export "%REPORTS_DIR%/%SPECIFIC_COLLECTION%_%TIMESTAMP%.html" --bail-exit-code 0
) ELSE (
    newman run collections/*.postman_collection.json -e %ENV_FILE% -r htmlextra --reporter-htmlextra-export "%REPORTS_DIR%/AllCollections_%TIMESTAMP%.html" --bail-exit-code 0
)