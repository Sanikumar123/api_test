@echo off
REM Usage: run_all.bat <env_file> <run_option> [specific_collection] [test_data_file]

SETLOCAL ENABLEDELAYEDEXPANSION

SET ENV_FILE=%~1
SET RUN_OPTION=%~2
SET SPECIFIC_COLLECTION=%~3
SET TEST_DATA_FILE=%~4

REM Default ENV_FILE
IF "%ENV_FILE%"=="" (
    SET ENV_FILE=environments\QA.postman_environment.json
)

REM Create reports folder if not exist
IF NOT EXIST reports (
    mkdir reports
)

REM Default RUN_OPTION
IF "%RUN_OPTION%"=="" (
    SET RUN_OPTION=All
)

echo =====================================
echo ENV_FILE: %ENV_FILE%
echo RUN_OPTION: %RUN_OPTION%
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
            echo ❌ Newman tests failed for %%~nxf
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
)

REM ===============================
REM Run SPECIFIC collection
REM ===============================
ELSE IF /I "%RUN_OPTION%"=="Specific" (

    IF "%SPECIFIC_COLLECTION%"=="" (
        echo ❌ Error: SPECIFIC_COLLECTION is empty
        exit /b 1
    )

    echo Running specific collection: %SPECIFIC_COLLECTION%

    IF "%TEST_DATA_FILE%"=="" (
        newman run "collections\%SPECIFIC_COLLECTION%" -e "%ENV_FILE%" -r cli,htmlextra ^
        --reporter-htmlextra-export "reports\%SPECIFIC_COLLECTION%_report.html"
    ) ELSE (
        newman run "collections\%SPECIFIC_COLLECTION%" -e "%ENV_FILE%" -d "test_data\%TEST_DATA_FILE%" -r cli,htmlextra ^
        --reporter-htmlextra-export "reports\%SPECIFIC_COLLECTION%_report.html"
    )

    IF %ERRORLEVEL% NEQ 0 (
        echo ❌ Newman tests failed for %SPECIFIC_COLLECTION%
        exit /b 1
    ) ELSE (
        echo ✅ Passed: %SPECIFIC_COLLECTION%
    )
)

REM ===============================
REM Invalid Option
REM ===============================
ELSE (
    echo ❌ Error: Unknown RUN_OPTION %RUN_OPTION%
    exit /b 1
)