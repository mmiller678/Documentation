```cmd
@echo off

set msbuildpath=
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MsBuild.exe" (
    set "msbuildpath=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MsBuild.exe"
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\Current\Bin\MsBuild.exe" (
    set "msbuildpath=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\Current\Bin\MsBuild.exe"
)

if "%msbuildpath%"=="" echo A valid version of MSBuild is not installed. >&2 & EXIT /b 1

if "%*" == "" GOTO NoTarget

:Target
"%msbuildpath%" build.targets /v:minimal /m /t:%*
GOTO End

:NoTarget
"%msbuildpath%" build.targets /v:minimal /m
:End
```
