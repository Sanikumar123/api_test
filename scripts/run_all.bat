@echo off
REM Usage: run_all.bat <env_file> <run_option> [specific_collection]

SET ENV_FILE=%1
SET RUN_OPTION=%2
SET SPECIFIC_COLLECTION=%3

IF "%ENV_FILE%"=="" (
    SET ENV_FILE=environments\QA.postman_environment.json
)

REM Make sure reports directory exists
IF NOT EXIST reports (
    mkdir reports
)

IF "%RUN_OPTION%"=="" (
    SET RUN_OPTION=All
)

IF /I "%RUN_OPTION%"=="All" (
    echo Running all collections in collections folder...
    for %%f in (collections\*.postman_collection.json) do (
        echo Running collection: %%~nxf
        newman run "%%f" -e "%ENV_FILE%" -r cli,html --reporter-html-export "reports\%%~nf_report.html"
        IF %ERRORLEVEL% NEQ 0 (
            echo "Newman tests failed for %%~nxf!"
        )
    )
) ELSE IF /I "%RUN_OPTION%"=="Specific" (
    IF "%SPECIFIC_COLLECTION%"=="" (
        echo "Error: SPECIFIC_COLLECTION parameter is empty."
        exit /b 1
    )
    echo Running specific collection: %SPECIFIC_COLLECTION%
    newman run "collections\%SPECIFIC_COLLECTION%" -e "%ENV_FILE%" -r cli,html --reporter-html-export "reports\%SPECIFIC_COLLECTION%_report.html"
    IF %ERRORLEVEL% NEQ 0 (
        echo "Newman tests failed for %SPECIFIC_COLLECTION%!"
        exit /b 1
    )
) ELSE (
    echo "Error: Unknown RUN_OPTION %RUN_OPTION%. Use All or Specific."
    exit /b 1
)