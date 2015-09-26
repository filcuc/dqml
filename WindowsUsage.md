1. Install DMD 
2. Install [implib](http://www.digitalmars.com/download/freecompiler.html). 
It's contained in the basic utilities
3. Install Qt 5.5 and from the installer components select
```
Qt -> Qt5.5 -> MinGW 4.9.2 32bit
Qt -> Tools -> MinGW 4.9.2
```
4. Install CMake 3
5.  Modify your PATH system variable and check that you don't have any reference to any build tool in your system.
   So no path to DMD, Tools, Qt, previous MinGW installation or whatever
6.  Create a new file on your desktop and call it env.bat
7.  Open it with notepad, add the following text and save
```
@echo off
REM COLOR 0A
SET QT_PATH=C:\Tools\Qt\5.5\mingw492_32\bin
SET MINGW_PATH=C:\Tools\Qt\Tools\mingw492_32\bin
SET IMPLIB_PATH=C:\Tools\D\dm
SET DMD_PATH=C:\Tools\D\dmd2\windows\bin
SET DUB_PATH=C:\Tools\dub
SET CMAKE_PATH=C:\Tools\CMake\bin
SET DOTHERSIDE_LIB_PATH=C:\Tools\DOtherSideLib
SET PATH=%QT_PATH%;%MINGW_PATH%;%IMPLIB_PATH%;%DMD_PATH%;%DUB_PATH%;%CMAKE_PATH%;%DOTHERSIDE_LIB_PATH%;%PATH%
cmd
```
8. Adapt the previous content with your system paths for the tools
9.  Double click on the .bat file. A cmd prompt should open
10.  Clone the DOtherSide project from git and navigate to its directory 
11.  From the DOtherSide directory type the following command
```
$) mkdir build
$) cd build
$) cmake -G "MinGW Makefiles" ..
$) mingw32-make
$) cd src
```
12. You should have the libDOtherSide.dll builded
13. Renamed to DOtherSide.dll 
```
$) mv libDOtherSide.dll DOtherSide.dll
```
14. Invoke implib for generating a .lib file compatible with the DMD linker:
```
$) implib /s DOtherSide.lib DOtherSide.dll
```
15. You should now have a DOtherSide.lib file
16. Move the DOtherSide.dll %DOTHERSIDE_LIB_PATH% you set at point (7)
17. Move the DOtherSide.lib inside your dmd compiler directory. In my case is "C:\Tools\D\dmd2\windows\lib" 
18. Clone the dqml repository
19. Navigate to dqml root directory and type:
```
$) cd examples
$) cd contactapp
$) dub
```
20. Profit!! :D
