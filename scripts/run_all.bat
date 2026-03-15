@echo off
REM Usage: run_all.bat <environment_file>

REM Default environment is QA
if "%1"=="" (
    set ENV_FILE=environments\QA.postman_environment.json
) else (
    set ENV_FILE=%1
)

if not exist reports mkdir reports

REM Loop through all Postman collections
for %%f in (collections\*.json) do (
    set COLLECTION=%%~nf
    echo Running %%f with environment %ENV_FILE% ...
    newman run "%%f" -e "%ENV_FILE%" ^
        --reporters cli,html,junit ^
        --reporter-html-export "reports\%%~nf.html" ^
        --reporter-junit-export "reports\%%~nf.xml"
)