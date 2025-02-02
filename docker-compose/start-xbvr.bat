@echo off
echo Starting docker...
docker desktop start

for /F "delims== tokens=1,* eol=#" %%i in (.env) do set %%i=%%~j

echo Checking if the volume realdebrid exists...
for /f "delims=" %%a in ('docker volume ls --format "{{.Name}}"') do (
    if "%%a"=="realdebrid" (
        set volume=realdebrid
    )
)
if "%volume%"=="realdebrid" (
    echo realdebrid volume already exists.
) else (
    echo realdebrid volume does not exist.
    echo Creating...
    docker volume create realdebrid -d rclone -o type=realdebrid -o realdebrid-api_key=%REALDEBRID_API_KEY% -o realdebrid-regex_shows="a^" -o realdebrid-regex_movies="a^" -o allow-other=true -o dir-cache-time=10s
    echo realdebrid volume created.
)

echo Starting services...
docker compose up -d
echo Services started.

start "" "chrome.exe" --incognito "http://localhost:9997"

docker compose logs xbvr --follow
