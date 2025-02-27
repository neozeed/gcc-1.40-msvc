nmake clean
nmake TARGET_CPU=i386
call inst.cmd i386
nmake clean
copy /Y ..\gas-1.38\i386as.exe bin\i386\as.exe

nmake TARGET_CPU=i860
call inst.cmd i860
nmake clean
copy /Y ..\gas-1.38\i860as.exe bin\i860\as.exe

nmake TARGET_CPU=m68k
call inst.cmd m68k
nmake clean
copy /Y ..\gas-1.38\m68kas.exe bin\m68k\as.exe

nmake TARGET_CPU=ns32k
call inst.cmd ns32k
nmake clean
copy /Y ..\gas-1.38\ns32kas.exe bin\ns32k\as.exe

nmake TARGET_CPU=sparc
call inst.cmd sparc
nmake clean
copy /Y ..\gas-1.38\sparcas.exe bin\sparc\as.exe

nmake TARGET_CPU=vax
call inst.cmd vax
nmake clean
copy /Y ..\gas-1.38\vaxas.exe bin\vax\as.exe