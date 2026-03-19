@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Usage: run_all.bat <env_file> <run_option> [specific_collection] [test_data_file]

SET ENV_FILE=%~1
SET RUN_OPTION=%~2
SET SPECIFIC_COLLECTION=%~3
SET TEST_DATA_FILE=%~4

REM Default ENV_FILE
IF "%ENV_FILE%"=="" (
    SET ENV_FILE=environments\QA.postman_environment.json
)

REM Default RUN_OPTION
IF "%RUN_OPTION%"=="" (
    SET RUN_OPTION=All
)

REM Create reports folder if not exist
IF NOT EXIST reports (
    mkdir reports
)

echo =====================================
echo ENV_FILE: %ENV_FILE%
echo RUN_OPTION: %RUN_OPTION%
echo SPECIFIC_COLLECTION: %SPECIFIC_COLLECTION%
echo TEST_DATA_FILE: %TEST_DATA_FILE%
echo =====================================

SET FAILED=0

REM ===============================
REM Run ALL collections
REM ===============================
IF /I "%RUN_OPTION%"=="All" (

    echo Running all collections...

    for %%f in (collections\*.postman_collection.json) do (
        echo -------------------------------------
        echo Running collection: %%~nxf

        IF "%TEST_DATA_FILE%"=="" (
            newman run "%%f" -e "%ENV_FILE%" -r cli,htmlextra ^
            --reporter-htmlextra-export "reports\%%~nf_report.html"
        ) ELSE (
            newman run "%%f" -e "%ENV_FILE%" -d "test_data\%TEST_DATA_FILE%" -r cli,htmlextra ^
            --reporter-htmlextra-export "reports\%%~nf_report.html"
        )

        IF !ERRORLEVEL! NEQ 0 (
            echo ❌ Failed: %%~nxf
            SET FAILED=1
        ) ELSE (
            echo ✅ Passed: %%~nxf
        )
    )

    IF !FAILED! NEQ 0 (
        echo =====================================
        echo ❌ One or more collections failed
        exit /b 1
    )

) ELSE IF /I "%RUN_OPTION%"=="Specific" (

    IF "%SPECIFIC_COLLECTION%"=="" (
        echo ❌ Error: SPECIFIC_COLLECTION is empty
        exit /b 1
    )

    SET COLLECTION_FILE=collections\%SPECIFIC_COLLECTION%.postman_collection.json

    IF NOT EXIST "!COLLECTION_FILE!" (
        echo ❌ Collection not found: !COLLECTION_FILE!
        exit /b 1
    )

    echo Running specific collection: !COLLECTION_FILE!

    IF "%TEST_DATA_FILE%"=="" (
        newman run "!COLLECTION_FILE!" -e "%ENV_FILE%" -r cli,htmlextra ^
        --reporter-htmlextra-export "reports\%SPECIFIC_COLLECTION%_report.html"
    ) ELSE (
        newman run "!COLLECTION_FILE!" -e "%ENV_FILE%" -d "test_data\%TEST_DATA_FILE%" -r cli,htmlextra ^
        --reporter-htmlextra-export "reports\%SPECIFIC_COLLECTION%_report.html"
    )

    IF !ERRORLEVEL! NEQ 0 (
        echo ❌ Failed: %SPECIFIC_COLLECTION%
        exit /b 1
    ) ELSE (
        echo ✅ Passed: %SPECIFIC_COLLECTION%
    )

) ELSE (
    echo ❌ Invalid RUN_OPTION: %RUN_OPTION%
    exit /b 1
)