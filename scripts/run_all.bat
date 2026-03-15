@echo off
SET ENV_FILE=%1

IF "%ENV_FILE%"=="" (
    SET ENV_FILE=environments\QA.postman_environment.json
)

REM Ensure reports folder exists
IF NOT EXIST reports (
    mkdir reports
)

REM Run Newman using local installation
node_modules\.bin\newman run collections\LibraryCollections.postman_collection.json ^
    -e "%ENV_FILE%" ^
    -r cli,html ^
    --reporter-html-export "reports/report.html"

IF %ERRORLEVEL% NEQ 0 (
    echo "Newman tests failed!"
    exit /b 1
)