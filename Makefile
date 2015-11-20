PYVER=27
CC=i686-w64-mingw32-gcc
WINDRES=i686-w64-mingw32-windres
ICO=dist/file-system.ico

QT_DLLS=""


PYQT_DIST=PyQt4-4.11.4-gpl-Py2.7-Qt4.8.7-x32.exe

all: pystdlib pydll smokeui.exe pyqt
	cp smokeui.exe pkg/
	zip smokeui.zip __main__.py
	cp smokeui.zip pkg/

pyqt:
	7z x -opkg/_pyqt dist/${PYQT_DIST}
	mkdir -p ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/sip.pyd ./pkg/
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtCLucene4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtCore4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtDeclarative4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtDesigner4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtDesignerComponents4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtGui4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtHelp4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtMultimedia4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtNetwork4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtOpenGL4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtScript4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtScriptTools4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtSql4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtSvg4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtTest4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtWebKit4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtXml4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtXmlPatterns4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/phonon4.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/libeay32.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/ssleay32.dll ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/libmysql.dll ./pkg/PyQt4
	cp -r ./pkg/_pyqt/Lib/site-packages/PyQt4/imports ./pkg/PyQt4
	cp -r ./pkg/_pyqt/Lib/site-packages/PyQt4/plugins ./pkg/PyQt4
	cp -r ./pkg/_pyqt/Lib/site-packages/PyQt4/translations ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/__init__.py ./pkg/PyQt4
	cp -r ./pkg/_pyqt/Lib/site-packages/PyQt4/uic ./pkg/PyQt4
	rm -rf ./pkg/PyQt4/uic/port_v3
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/Qt.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtCore.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtDeclarative.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtDesigner.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtGui.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtHelp.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtMultimedia.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtNetwork.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtOpenGL.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtScript.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtScriptTools.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtSql.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtSvg.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtTest.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtWebKit.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtXml.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QtXmlPatterns.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/QAxContainer.pyd ./pkg/PyQt4
	cp ./pkg/_pyqt/Lib/site-packages/PyQt4/phonon.pyd ./pkg/PyQt4
	cd ./pkg/PyQt4 && python2 -m compileall -d PyQt4 . || true
	find ./pkg/PyQt4 -type f -name '*.py' | xargs rm
	echo -en "Prefix = PyQt4\r\n" >> ./pkg/qt.conf
	echo -en "Binaries = PyQt4\r\n" >> ./pkg/qt.conf
	echo -en "Prefix = .\r\n" >> ./pkg/PyQt4/qt.conf
	echo -en "Binaries = .\r\n" >> ./pkg/PyQt4/qt.conf
	rm -rf ./pkg/_pyqt

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
	mkdir -p ./pkg/lib
	cp -r dist/Lib/* pkg/lib
	find pkg/lib -type d -name test | xargs rm -rf
	cd pkg/lib && python2 -m compileall -d python${PYVER}.zip . || true
	find pkg/lib -type f -name '*.py' | xargs rm
	cd pkg/lib && zip -r python${PYVER}.zip *
	mv pkg/lib/python${PYVER}.zip pkg/
	rm -rf ./pkg/lib/

.PHONY: pyexe
pydll:
	mkdir -p ./pkg
	cp dist/DLLs/*.pyd pkg/
	cp dist/DLLs/sqlite3.dll pkg/
	cp msvcr90.dll pkg/
	cp dist/python${PYVER}.dll pkg/

clean:
	rm -rf ./pkg
	rm *.o
	rm *.zip
