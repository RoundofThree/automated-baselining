@ECHO OFF

ECHO Updating baseline TXT files...

del network-baseline.txt 2>nul
for /f "tokens=1,2 delims= " %%a in ('"netstat -nao | findstr "LISTENING""') do (echo %%a %%b) >> network-baseline.txt

del process-baseline.txt 2>nul
for /f "tokens=2" %%a in ('"wmic process list brief"') do (echo %%a) >> process-baselinetmp.txt
(type process-baselinetmp.txt | sort /unique) > process-baseline.txt
del process-baselinetmp.txt


del service-baseline.txt 2>nul
for /f "tokens=2" %%a in ('"sc query | findstr SERVICE_NAME"') do (echo %%a) >> service-baseline.txt

del scheduled-baseline.txt 2>nul
for /f "tokens=1" %%a in ('"schtasks | findstr "Running Ready Disabled""') do (echo %%a) >> scheduled-tmp.txt
(type scheduled-tmp.txt | sort /unique) > scheduled-baseline.txt
del scheduled-tmp.txt

del registry-baseline.txt 2>nul
reg query HKLM\software\microsoft\windows\currentversion\run >> registry-baseline.txt
reg query HKLM\software\microsoft\windows\currentversion\runonce >> registry-baseline.txt
reg query HKLM\software\microsoft\windows\currentversion\runonceex >> registry-baseline.txt 2>nul

del startup-folders-baseline.txt 2>nul
dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" >> startup-folders-baseline.txt
dir "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" >> startup-folders-baseline.txt

net user > users-tmp.txt
net localgroup administrators > administrators-tmp.txt

del bigfile-baseline.txt 2>nul
for /r c:\ %%i in (*) do @if %%~zi gtr 100000000 (echo %%i && dir /q "%%i" | findstr "AM PM" && echo -------------------------------) >> bigfile-baseline.txt

ECHO Finished! 
pause