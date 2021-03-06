# PIC32MX usbhost build make file
# with PinguinoX.4 (gcc 4.6)
# This build system came from AVR etc page
# http://hp.vector.co.jp/authors/VA000177/html/FrontPage.html
#

MCS=../../../../../microchip_solutions_v2013-06-15
MPBASE=/Applications/microchip/xc32/v1.20
PINPATH=../../../../pinguinoX.4-rev959
PROGDIR=../../../pic32prog

MP=$(MPBASE)/pic32mx
BTSTACK_ROOT=../..

# for PIC32MX220F032B
#LKRSCRIPT=selfboot.ld
#PROC=32MX220F032B

# for PIC32MX230F064B
#LKRSCRIPT=selfboot64.ld
#PROC=32MX230F064B

# for PIC32MX250F128B
LKRSCRIPT=selfboot128.ld
PROC=32MX250F128B

#HEAP_SIZE=512
HEAP_SIZE=2048
#HEAP_SIZE=4096

CC=$(PINPATH)/macosx/p32/bin/mips-elf-gcc
OBJC=$(PINPATH)/macosx/p32/bin/avr-objcopy
OBJDUMP=$(PINPATH)/macosx/p32/bin/mips-elf-objdump
SIZE=$(PINPATH)/macosx/p32/bin/mips-elf-size
PROG=$(PROGDIR)/pic32prog

MIPS16=-mips16

PICLIBS=$(MP)/lib/no-float/libmchp_peripheral_$(PROC).a
PROCESSOR_O=processor.o

LDFLAGS=-msoft-float -Wl,--gc-sections $(MIPS16) \
	-L. -L$(MP)/lib/proc/$(PROC)/ \
	-Wl,--defsym,_min_heap_size=$(HEAP_SIZE) \
	-Wl,-Map=output.map \
	-T$(LKRSCRIPT) \
	-T$(PINPATH)/p32/lkr/elf32pic32mx.x

ELF_FLAGS=-EL -Os -ffunction-sections -fdata-sections -march=24kc 

INCLUDEDIRS=-I. -I$(BTSTACK_ROOT)/include -I$(BTSTACK_ROOT)/src \
	-I$(BTSTACK_ROOT)/ble \
	-I$(MCS)/USB -I$(MCS)/Microchip/Include -I$(MCS)/Microchip/USB \
	-I$(MP)/include -IMicrochip/Include/USB/

include ./Objs.mak

CFLAGS=-fdollars-in-identifiers $(INCLUDEDIRS) -G0
CFLAGS+=-D__PIC32MX__ -D__$(PROC)__
CFLAGS+=-D__PIC32_FEATURE_SET__=200
#CFLAGS+=-DCONFIG_12MHz
#CFLAGS+=-DUSBHOSTBT_DEBUG
CFLAGS+=-D__XC32

all: ancs_client.h $(OBJS)
	cp $(MP)/lib/proc/$(PROC)/processor.o .
	$(CC) $(ELF_FLAGS) $(CFLAGS) -o ancs_client.elf \
		$(PROCESSOR_O) \
		$(OBJS) \
		$(PICLIBS) \
		$(LDFLAGS) \
		-lm -lgcc -lc
	$(OBJC) -O ihex ancs_client.elf ancs_client.hex

ancs_client.h : ../../example/embedded/ancs_client.gatt
	python ${BTSTACK_ROOT}/ble/compile-gatt.py $< $@ 

%.o : %.c
	$(CC) $(ELF_FLAGS) $(CFLAGS) $(MIPS16) -c $< -o $@

TimeDelay.o : $(MCS)/Microchip/Common/TimeDelay.c
	$(CC) $(ELF_FLAGS) $(CFLAGS) $(MIPS16) -c $< -o $@

crt.o : crt0.S
	$(CC) $(ELF_FLAGS) -I$(PINPATH)/p32/include/non-free -c $< -o $@

size:
	$(SIZE) ancs_client.elf

objdump:
	$(OBJDUMP) -m mips:isa32r2 -b ihex -D ancs_client.hex

flash:
	$(PROG) -S ancs_client.hex

clean:
	rm -f *.o PIC32/*.o PIC32_USB/*o $(BTSTACK_ROOT)/src/*.o \
	$(BTSTACK_ROOT)/ble/*.o ../../example/embedded/*.o \
	Microchip/USB/*.o *.elf *.hex *.map ancs_client.h
