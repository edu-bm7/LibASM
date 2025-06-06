AS = nasm
CC = gcc
CFLAGS = -g -Wall -Wextra -pedantic -Werror
LDFLAGS = 
ASFLAGS = -g -F dwarf -Werror
ALL_ASFLAGS = -f elf64
ALL_LDFLAGS = -pie -Wl,--fatal-warnings

ALL_CFLAGS += -fPIE -m64 $(CFLAGS)
ALL_LDFLAGS += $(LDFLAGS)
ALL_ASFLAGS += $(ASFLAGS)

C_OBJS = $(patsubst %.c, %.o, $(wildcard *.c))
AS_OBJS = $(patsubst %.s, %.o, $(wildcard *.s))
ALL_OBJS += $(C_OBJS)
ALL_OBJS += $(AS_OBJS)

CC_CMD = $(CC) $(ALL_CFLAGS) -c -o $@ $<

all: tests
	./$<
tests: $(ALL_OBJS)
	$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) -o $@ $(ALL_OBJS)

%.o: %.s
	$(AS) $(ALL_ASFLAGS) -o $@ $<

%.o: %.c
	$(CC_CMD)

clean:
	rm -f *.o

.PHONY: all clean


