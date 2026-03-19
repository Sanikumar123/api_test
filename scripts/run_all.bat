@echo off

SET ENV_FILE=%~1
SET RUN_OPTION=%~2
SET SPECIFIC_COLLECTION=%~3
SET TEST_DATA_FILE=%~4

echo =====================================
echo ENV_FILE: %ENV_FILE%
echo RUN_OPTION: %RUN_OPTION%
echo SPECIFIC_COLLECTION: %SPECIFIC_COLLECTION%
echo TEST_DATA_FILE: %TEST_DATA_FILE%
echo =====================================

SET REPORTS_DIR=reports
IF NOT EXIST %REPORTS_DIR% (
    mkdir %REPORTS_DIR%
)

SET TIMESTAMP=%DATE:~-4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
SET TIMESTAMP=%TIMESTAMP: =0%

IF /I "%RUN_OPTION%"=="Specific" (

    SET COLLECTION=collections\%SPECIFIC_COLLECTION%.postman_collection.json

    echo Running: %COLLECTION%

    IF "%TEST_DATA_FILE%"=="" (
        newman run "%COLLECTION%" -e "%ENV_FILE%" -r cli,htmlextra ^
        --reporter-htmlextra-export "%REPORTS_DIR%\%SPECIFIC_COLLECTION%_%TIMESTAMP%.html"
    ) ELSE (
        newman run "%COLLECTION%" -e "%ENV_FILE%" -d "test_data\%TEST_DATA_FILE%" -r cli,htmlextra ^
        --reporter-htmlextra-export "%REPORTS_DIR%\%SPECIFIC_COLLECTION%_%TIMESTAMP%.html"
    )

    exit /b %ERRORLEVEL%

) ELSE (

    FOR %%f IN (collections\*.postman_collection.json) DO (

        echo Running: %%~nxf

        IF "%TEST_DATA_FILE%"=="" (
            newman run "%%f" -e "%ENV_FILE%" -r cli,htmlextra ^
            --reporter-htmlextra-export "%REPORTS_DIR%\%%~nf_%TIMESTAMP%.html"
        ) ELSE (
            newman run "%%f" -e "%ENV_FILE%" -d "test_data\%TEST_DATA_FILE%" -r cli,htmlextra ^
            --reporter-htmlextra-export "%REPORTS_DIR%\%%~nf_%TIMESTAMP%.html"
        )

        IF %ERRORLEVEL% NEQ 0 (
            exit /b %ERRORLEVEL%
        )
    )
)