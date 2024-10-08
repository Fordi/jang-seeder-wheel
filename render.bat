@echo off
setlocal
where /q docker
if ERRORLEVEL 1 (
  echo "Docker is not installed.  Please install docker: https://www.docker.com/products/docker-desktop/"
  exit /B
)
: Create the docker image if it doesn't exist
for /f %%i in ('docker images -q seed-roller-renderer') do set imageId=%%i
if "%imageId%" == "" (
  docker build -t seed-roller-renderer %~dp0
)

: Delete the container if it already exists
for /f %%i in ('docker container ls -aqf "name=^seed-roller-renderer"') do set containerId=%%i
if NOT "%containerId%" == "" (
  docker container rm seed-roller-renderer
)

cd %~dp0

: Create and run the container, and clean up.
docker run --name seed-roller-renderer --rm -v "%CD%":/input --entrypoint /input/render.sh -t seed-roller-renderer %*
