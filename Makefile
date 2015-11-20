PYVER=27
CC=i686-w64-mingw32-gcc
WINDRES=i686-w64-mingw32-windres
ICO=dist/file-system.ico

all: pystdlib pydll smokeui.exe
	cp smokeui.exe pkg/
	zip smokeui.zip __main__.py
	cp smokeui.zip pkg/

smokeui.exe: file-system-ico.o smokeui.o
	$(CC) -o smokeui.exe smokeui.o file-system-ico.o -Lpkg/ -lpython${PYVER}

%.o : %.c
	$(CC) -c -Idist/include -o $@ $<

.rc.o:
	$(WINDRES) $^ -o $@

%.o : %.rc
	$(WINDRES) $^ -o $@

.PHONY: pystdlib
pystdlib:
	rm -rf pkg/
	mkdir -p pkg/lib
	cp -r dist/Lib/* pkg/lib
	find pkg/lib -type d -name test | xargs rm -rf
	cd pkg/lib && python2 -m compileall -d python${PYVER}.zip . || true
	find pkg/lib -type f -name '*.py' | xargs rm
	cd pkg/lib && zip -r python${PYVER}.zip *
	mv pkg/lib/python${PYVER}.zip pkg/
	rm -rf pkg/lib/

.PHONY: pyexe
pydll:
	cp dist/DLLs/*.pyd pkg/
	cp dist/DLLs/sqlite3.dll pkg/
	cp msvcr90.dll pkg/
	cp dist/python${PYVER}.dll pkg/
