copy "%RECIPE_DIR%\build.sh" .
set PREFIX_WIN=%PREFIX%
set PREFIX=%PREFIX:\=/%
set LIBRARY_PREFIX_WIN=%LIBRARY_PREFIX%
set LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%
set LIBRARY_PREFIX_COIN=%LIBRARY_PREFIX%/include/coin


rem Temporarily store the expanded value of PREFIX
set TEMP_PREFIX=%PREFIX%
rem Expand LIBRARY_PREFIX by replacing %PREFIX% with the actual value of TEMP_PREFIX
call set LIBRARY_PREFIX_EXPANDED=%%LIBRARY_PREFIX:%PREFIX%=%TEMP_PREFIX%%%

rem Temporarily store the expanded value of PREFIX
set TEMP_PREFIX_WIN=%PREFIX_WIN%
rem Expand LIBRARY_PREFIX by replacing %PREFIX% with the actual value of TEMP_PREFIX
call set LIBRARY_PREFIX_WIN_EXPANDED=%%LIBRARY_PREFIX_WIN:%PREFIX%=%TEMP_PREFIX_WIN%%%

set SRC_DIR=%SRC_DIR:\=/%
set MSYSTEM=MINGW%ARCH%
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1
set BUILD_PLATFORM=win-64


bash -lc "./build.sh"
