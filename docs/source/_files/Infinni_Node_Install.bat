set INFINNI_NODE_VERSION=%1

nuget install "Infinni.Node" -Version %INFINNI_NODE_VERSION% -OutputDirectory "packages" -NonInteractive -Prerelease -Source "http://nuget.org/api/v2;http://nuget.infinnity.ru/api/v2"
powershell -NoProfile -ExecutionPolicy Bypass -Command ".\packages\Infinni.Node.%INFINNI_NODE_VERSION%\lib\net45\Install.ps1"
rd /s /q packages
cd Infinni.Node.%INFINNI_NODE_VERSION%