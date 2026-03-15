@echo off
REM Create reports folder if it doesn't exist
if not exist reports mkdir reports

REM Loop through all collections
for %%f in (collections\*.json) do (
    set COLLECTION=%%~nf
    echo Running %%f ...

    REM Run Newman with environment JSON, generate HTML and JUnit reports
    newman run "%%f" -e "environments\staging.postman_environment.json" ^
        --reporters cli,html,junit ^
        --reporter-html-export "reports\%%~nf.html" ^
        --reporter-junit-export "reports\%%~nf.xml"
)