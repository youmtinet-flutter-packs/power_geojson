@echo off
setlocal enabledelayedexpansion

:: Initialize variables
set "commitMessage="
set "tagName="
set "remoteName="

:: Parse named parameters
:parse
if "%~1"=="" goto validate

if "%~1"=="-m" (
    set "commitMessage=%~2"
    shift
)
if "%~1"=="-t" (
    set "tagName=%~2"
    shift
)
if "%~1"=="-r" (
    set "remoteName=%~2"
    shift
)
shift
goto parse

:: Validate required parameters
:validate
if "%commitMessage%"=="" (
    echo Error: Missing commit message. Use -m "message"
    exit /b 1
)

if "%tagName%"=="" (
    echo Error: Missing tag name. Use -t "tag_name"
    exit /b 1
)

if "%remoteName%"=="" (
    echo Error: Missing remote name. Use -r "remote"
    exit /b 1
)

:: Commit, tag, and push
echo "%commitMessage%"
git add .
git commit -m "%commitMessage%"
git tag "%tagName%"
git push --tags
git push -u "%remoteName%"

echo Done!
