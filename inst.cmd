mkdir bin
mkdir bin\%1
copy /Y cc1.exe bin\%1
copy /Y xgcc.exe bin\%1
copy /Y cccp.exe bin\%1\cpp.exe