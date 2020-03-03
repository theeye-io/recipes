REM Checks if Windows is locked
tasklist | findstr LogonUI.exe
if %errorlevel% NEQ 0 (echo success) else (echo failure)