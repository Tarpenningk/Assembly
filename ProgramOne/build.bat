@echo off
cls

set EXE_NAME=plane_line
del %EXE_NAME%.exe
del %EXE_NAME%.obj
del %EXE_NAME%.ilk
del %EXE_NAME%.pdb

set DRIVE_LETTER=%1:
set PATH=%DRIVE_LETTER%\Assembly\bin;c:\Windows;c:\Windows\system32
set INCLUDE=%DRIVE_LETTER%\Assembly\include
set LIB_DIRS=%DRIVE_LETTER%\Assembly\lib
set LIBS=sqrt.obj

ml -c -coff %EXE_NAME%.asm
link /libpath:%LIB_DIRS% %EXE_NAME%.obj %LIBS% io.obj kernel32.lib /debug /out:%EXE_NAME%.exe /subsystem:console /entry:start
%EXE_NAME% < plane_line.txt
