# Nmake macros for building Windows 32-Bit apps
CPU=i386
!include <ntwin32.mak>

TARGET_CPU=i386
#TARGET_CPU=i860
#TARGET_CPU=m68k
#TARGET_CPU=ns32k
#TARGET_CPU=sparc
#TARGET_CPU=vax

TARG=config\$(TARGET_CPU)
#
#CFLAGS= /Ic:\xenixnt\h /I. /Iconfig
#CFLAGS= /Ic:\msvc32s\include /I. /Iconfig
CFLAGS= /I. /Iconfig

#CC = cl /Od
CC = cl /O

CC1OBJ = c-tab.obj c-decl.obj c-typeck.obj c-conv.obj toplev.obj version.obj \
	tree.obj print-tree.obj stor-layout.obj fold-const.obj rtl.obj rtlanal.obj \
	expr.obj stmt.obj expmed.obj explow.obj optabs.obj varasm.obj symout.obj \
	dbxout.obj sdbout.obj emit-rtl.obj integrate.obj jump.obj cse.obj \
	loop.obj flow.obj stupid.obj combine.obj regclass.obj local-alloc.obj global-alloc.obj \
	reload.obj reload1.obj caller-save.obj final.obj recog.obj pragma.obj \
	errno.obj

CC1INSNOBJ = insn-emt.obj insn-xrt.obj insn-out.obj insn-pep.obj insn-rcg.obj \
	obstack.obj

CC1DEPS = insn-flags.h insn-codes.h insn-config.h insn-emt.c insn-pep.c insn-rcg.c \
	insn-xrt.c insn-out.c insn-out.obj

CCCPOBJ = cccp.obj cexp.obj version.obj obstack.obj alloca.obj

!IF "$(TARGET_CPU)" == "i386"
CFLAGS = $(CFLAGS) /DTARGET_CPU_I386
!ENDIF

!IF "$(TARGET_CPU)" == "i860"
CFLAGS = $(CFLAGS) /DTARGET_CPU_I860
!ENDIF

!IF "$(TARGET_CPU)" == "m68k"
CFLAGS = $(CFLAGS) /DTARGET_CPU_M68K
!ENDIF

!IF "$(TARGET_CPU)" == "ns32k"
CFLAGS = $(CFLAGS) /DTARGET_CPU_NS32K
!ENDIF

!IF "$(TARGET_CPU)" == "sparc"
# Only SPARC needs this
CC1OBJ = $(CC1OBJ) isinf.obj
CFLAGS = $(CFLAGS) /DTARGET_CPU_SPARC
!ENDIF

!IF "$(TARGET_CPU)" == "vax"
CFLAGS = $(CFLAGS) /DTARGET_CPU_VAX
!ENDIF

default: cc1.exe cccp.exe xgcc.exe

cc1: cc1.exe

cc1.exe: $(CC1DEPS) $(CC1OBJ) $(CC1INSNOBJ) insn-flags.h insn-config.h
	$(link) $(conflags) -out:cc1.exe $(CC1OBJ) $(CC1INSNOBJ) alloca.obj $(conlibs)

cccp.exe: $(CCCPOBJ)
	$(link) $(conflags) -out:cccp.exe $(CCCPOBJ) $(conlibs)

cc1x.exe: $(CC1DEPS) $(CC1OBJ) $(CC1INSNOBJ) insn-flags.h insn-config.h
	link /NODEFAULTLIB:libc.lib /NODEFAULTLIB:OLDNAMES.LIB  -out:cc1.exe $(CC1OBJ) $(CC1INSNOBJ) alloca.obj $(conlibs)

genflags.exe: c-tab.obj c-decl.obj c-typeck.obj c-conv.obj toplev.obj \
	version.obj tree.obj print-tree.obj stor-layout.obj fold-const.obj \
	rtl.obj rtlanal.obj genflags.obj obstack.obj \
	genflags.obj rtl.obj obstack.obj alloca.obj
	$(link) $(conflags) -out:genflags.exe genflags.obj rtl.obj obstack.obj alloca.obj $(conlibs)

%.obj: %.c
	$(CC) $(CFLAGS) /c $<
#	cvtomf -g $*.obj

gencodes.exe: gencodes.obj rtl.obj obstack.obj alloca.obj
	$(link) $(conflags) -out:gencodes.exe gencodes.obj rtl.obj obstack.obj alloca.obj $(conlibs)

genconfig.exe: genconfig.obj rtl.obj obstack.obj alloca.obj
	$(link) $(conflags) -out:genconfig.exe genconfig.obj rtl.obj obstack.obj alloca.obj $(conlibs)


genemit.exe: expr.obj stmt.obj expmed.obj explow.obj optabs.obj varasm.obj \
	symout.obj dbxout.obj sdbout.obj emit-rtl.obj genemit.obj \
	insn-config.h insn-flags.h
	$(link) $(conflags) -out:genemit.exe genemit.obj rtl.obj obstack.obj alloca.obj $(conlibs)

genpeep.exe: insn-emt.obj integrate.obj jump.obj cse.obj loop.obj \
	flow.obj stupid.obj combine.obj regclass.obj local-alloc.obj \
	global-alloc.obj reload.obj reload1.obj caller-save.obj genpeep.obj \
	rtl.obj obstack.obj alloca.obj
	$(link) $(conflags) -out:genpeep.exe genpeep.obj rtl.obj obstack.obj alloca.obj $(conlibs)

genrecog.exe: insn-pep.obj final.obj recog.obj genrecog.obj alloca.obj
	$(link) $(conflags) -out:genrecog.exe genrecog.obj rtl.obj obstack.obj alloca.obj $(conlibs)

genextract.exe: insn-rcg.obj genextract.obj alloca.obj
	$(link) $(conflags) -out:genextract.exe genextract.obj rtl.obj obstack.obj alloca.obj $(conlibs)

genoutput.exe: insn-xrt.obj genoutput.obj genoutput.obj rtl.obj obstack.obj alloca.obj
	$(link) $(conflags) -out:genoutput.exe genoutput.obj rtl.obj obstack.obj alloca.obj $(conlibs)

expr.obj: insn-flags.h insn-config.h insn-codes.h

insn-out.c: genoutput.exe
	genoutput.exe $(TARG).md > insn-out.c

insn-xrt.c: genextract.exe
	genextract $(TARG).md > insn-xrt.c

insn-rcg.c: genrecog.exe
	genrecog $(TARG).md > insn-rcg.c

insn-flags.h: genflags.exe
	genflags $(TARG).md > insn-flags.h

insn-codes.h: gencodes.exe
	gencodes $(TARG).md > insn-codes.h

insn-config.h: genconfig.exe
	genconfig $(TARG).md > insn-config.h

insn-emt.c: genemit.exe
	genemit $(TARG).md > insn-emt.c

insn-pep.c: genpeep.exe
	genpeep $(TARG).md > insn-pep.c


insn-out.obj: insn-out.c
	$(CC) $(CFLAGS) /D_WIN32 /D__STDC__ /I. /Iconfig /c insn-out.c

c-tab.c: c-parse.y
	copy /Y ..\bison-1.16\bison.simple .
	..\bison-1.16\bison.exe  -v ./c-parse.y -o c-tab.c
	del /Q c-tab.output bison.simple

cexp.c: cexp.y
	copy /Y ..\bison-1.16\bison.simple .
	..\bison-1.16\bison.exe  -v ./cexp.y -o cexp.c
	del /Q cexp.output bison.simple

xgcc.exe: gcc.obj obstack.obj alloca.obj version.obj newargcv.obj
	$(link) $(conflags) -out:xgcc.exe gcc.obj obstack.obj alloca.obj version.obj newargcv.obj $(conlibs)
	

clean:
	del /F *.obj
	del /F *.exe
	del /F insn-*
	del /F stamp-*
	del /F c-parse.output c-tab.c cexp.c
