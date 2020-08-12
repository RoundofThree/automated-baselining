@ECHO OFF

ECHO Comparing system with baseline...

ECHO -------------------
ECHO Comparing network usage (listening ports)...
for /f "tokens=1,2 delims= " %%a in ('"netstat -nao | findstr "LISTENING""') do (echo %%a %%b) >> network-tmp.txt
:: comp network-tmp.txt network-baseline.txt
ECHO Different ports (could be blank): 
findstr /livxg:"network-baseline.txt" network-tmp.txt
del network-tmp.txt

pause

ECHO -------------------
ECHO Comparing processes...
for /f "tokens=2" %%a in ('"wmic process list brief"') do (echo %%a) >> process-baselinetmp.txt
(type process-baselinetmp.txt | sort /unique) > process-baselinetmp1.txt
:: comp process-baselinetmp1.txt process-baseline.txt
ECHO Different processes (could be blank): 
findstr /livxg:"process-baseline.txt" process-baselinetmp1.txt
del process-baselinetmp.txt && del process-baselinetmp1.txt

pause

ECHO -------------------
ECHO Comparing services...
for /f "tokens=2" %%a in ('"sc query | findstr SERVICE_NAME"') do (echo %%a) >> service-tmp.txt
ECHO Different services (could be blank): 
findstr /livxg:"service-baseline.txt" service-tmp.txt
del service-tmp.txt

pause

ECHO -------------------
ECHO Comparing scheduled tasks...
for /f "tokens=1" %%a in ('"schtasks | findstr "Running Ready Disabled""') do (echo %%a) >> scheduled-tmp.txt
(type scheduled-tmp.txt | sort /unique) > scheduled-tmp1.txt
ECHO Different scheduled tasks (could be blank): 
findstr /livxg:"scheduled-baseline.txt" scheduled-tmp1.txt
del scheduled-tmp.txt && del scheduled-tmp1.txt

pause

ECHO -------------------
ECHO Comparing ASEPs in registry and windows startup folders...
del registry-tmp.txt 2>nul
reg query HKLM\software\microsoft\windows\currentversion\run >> registry-tmp.txt
reg query HKLM\software\microsoft\windows\currentversion\runonce >> registry-tmp.txt
reg query HKLM\software\microsoft\windows\currentversion\runonceex >> registry-tmp.txt 2>nul
ECHO Different registry keys (could be blank): 
findstr /livxg:"registry-asep-baseline.txt" registry-tmp.txt
del registry-tmp.txt

del startup-folders-tmp.txt 2>nul
dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" >> startup-folders-tmp.txt
dir "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" >> startup-folders-tmp.txt
ECHO Different startup items in Startup folders (could be blank):
findstr /livxg:"startup-folders-baseline.txt" startup-folders-tmp.txt
del startup-folders-tmp.txt

pause

ECHO -------------------
ECHO Comparing users and admins...
net user > users-tmp.txt
net localgroup administrators > administrators-tmp.txt
ECHO Different users or admins (could be blank): 
findstr /livxg:"users-baseline.txt" users-tmp.txt
findstr /livxg:"administrators-baseline.txt" administrators-tmp.txt
del users-tmp.txt && del administrators-tmp.txt

pause

ECHO -------------------
ECHO Comparing big files...
for /r c:\ %%i in (*) do @if %%~zi gtr 100000000 (echo %%i && dir /q "%%i" | findstr "AM PM" && echo -------------------------------) >> bigfile-tmp.txt
ECHO Different big files (could be blank):
findstr /livxg:"bigfile-baseline.txt" bigfile-tmp.txt
del bigfile-tmp.txt

pause

ECHO -------------------
ECHO Use DeepBlueCLI.ps1 to review logs for Security and System: 
ECHO "> powershell"
ECHO "> \tools\deepbluecli.ps1 -log Security (consider out-gridview)"

ECHO -------------------
ECHO Finished! 
