@echo off
echo "INICIO COMPILADOR"
c:\GnuWin32\bin\flex .\lex.l
echo "terminado compilado flex"
pause
c:\GnuWin32\bin\bison -dv .\parser.y
echo "terminado compilado bison"
pause
c:\MinGW\bin\gcc .\lex.yy.c .\parser.tab.c -o compilador
del lex.yy.c
del parser.tab.c
del parser.output
del parser.tab.h
echo "elimando archivos innecesarios"
echo "FIN COMPILADOR"