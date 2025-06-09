AS = nasm
CC = gcc
NAME = libasm.a
CFLAGS = -g -Wall -Wextra -pedantic -Werror
LDFLAGS = -L. -lasm
ASFLAGS = -g -F dwarf -Werror
ALL_ASFLAGS = -f elf64
ALL_LDFLAGS = -pie -Wl,--fatal-warnings

ALL_CFLAGS += -fPIE -m64 $(CFLAGS)
ALL_LDFLAGS += $(LDFLAGS)
ALL_ASFLAGS += $(ASFLAGS)

C_OBJS = $(patsubst %.c, %.o, $(wildcard *.c))
AS_OBJS = $(patsubst %.s, %.o, $(wildcard *.s))

CC_CMD = $(CC) $(ALL_CFLAGS) -c -o $@ $<

$(NAME): $(AS_OBJS)
	@ar rcs $(NAME) $?
	@echo "--------------------------"
	@echo "Libft created and indexed."
	@echo "--------------------------"

all: $(NAME)

tests: $(NAME) $(C_OBJS)
	$(CC) $(ALL_CFLAGS) $(C_OBJS) -o $@ $(ALL_LDFLAGS)

%.o: %.s
	$(AS) $(ALL_ASFLAGS) -o $@ $<

%.o: %.c
	$(CC_CMD)

clean:
	rm -f *.o

fclean: clean
	rm -f tests libasm.a

.PHONY: all clean fclean

