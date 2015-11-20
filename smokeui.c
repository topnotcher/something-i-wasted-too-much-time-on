#include "Python.h"

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <string.h>

int WINAPI WinMain(
	HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPSTR lpCmdLine,
	int nCmdShow
) {
	char zip_file[] = "smokeui.zip";

	char full_path[MAX_PATH + sizeof(zip_file) + 1];
	DWORD WINAPI status = GetModuleFileName(NULL, full_path, MAX_PATH);

	char *sptr = strrchr(full_path, '\\');
	if (sptr) {
		strncpy(sptr + 1, zip_file, sizeof(zip_file) + 1);
	} else {
		strncpy(full_path, zip_file, sizeof(zip_file) + 1);
	}

	// Arguments to 'add' to the python command line
	char *argv_add[] = {full_path};
	const int argc_add = sizeof(argv_add)/sizeof(argv_add[0]);

	int argc_new = __argc + argc_add;
	char *argv_new[argc_new];
	int argv_new_offset = 0;

	// add the old argv[0] to the new arglist
	if (__argc > 0) 
		argv_new[argv_new_offset++] = __argv[0];	
	
	// add all of argv_add to the new arglist
	for (int i = 0; i < argc_add; ++i)
		argv_new[argv_new_offset++] = argv_add[i];

	// now add all of the old arguments
	for (int i = 1; i < __argc; ++i)
		argv_new[argv_new_offset++] = __argv[i];

	Py_Main(argc_new, argv_new);
	return 0;
}
