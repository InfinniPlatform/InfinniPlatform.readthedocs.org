@echo To install sphinx-autobuild run command:
@echo $ pip install sphinx-autobuild
start cmd /c sphinx-autobuild.exe source build/html
start "" http://localhost:8000