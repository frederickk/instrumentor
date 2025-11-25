@echo off
if not exist "build" mkdir build
if not exist "dist" mkdir dist

lcc -Wa-l -c -o build\instrument1.o instrument1.c || exit /b 1
lcc -Wa-l -c -o build\font.o font.c || exit /b 1
lcc -Wl-m -Wl-j -Wm-yc -o dist\instrumentor.gb build\instrument1.o build\font.o || exit /b 1

