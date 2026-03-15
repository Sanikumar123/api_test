@echo off
REM Usage: run_all.bat <ENV_FILE> [<COLLECTION_NAME>]

SET ENV_FILE=%1
SET COLLECTION_NAME=%2

IF "%ENV_FILE%"=="" (
    SET ENV_FILE=environments\QA.postman_environment.json
)

REM Make sure reports directory exists
IF NOT EXIST reports (
    mkdir reports
)

IF "%COLLECTION_NAME%"=="" (
    REM Run all collections
    FOR %%F IN (collections\*.postman_collection.json) DO (
        SET COLL_NAME=%%~nF
        echo Running collection: %%F
        newman run %%F -e "%ENV_FILE%" -r cli,html --reporter-html-export "reports\%%~nF_report.html"
        IF ERRORLEVEL 1 (
            echo "Newman tests failed for %%F!"
        )
    )
) ELSE (
    REM Run specific collection
    SET COLL_FILE=collections\%COLLECTION_NAME%.postman_collection.json
    IF NOT EXIST "%COLL_FILE%" (
        echo "Collection file %COLL_FILE% not found!"
        exit /b 1
    )
    echo Running specific collection: %COLL_FILE%
    newman run "%COLL_FILE%" -e "%ENV_FILE%" -r cli,html --reporter-html-export "reports\%COLLECTION_NAME%_report.html"
    IF ERRORLEVEL 1 (
        echo "Newman tests failed for %COLLECTION_NAME%!"
        exit /b 1
    )
)

echo "All collections executed."