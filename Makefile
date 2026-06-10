NAME = libasm

CC = gcc

CFLAGS = -Wall -Wextra -Werror

AS = nasm

ASFLAGS = -f elf64

SRC_DIR = src

C_SRC = main.c

S_SRC = ft_hello_world.s ft_strlen.s

OBJ_DIR = obj

OBJ = $(addprefix $(OBJ_DIR)/, $(C_SRC:.c=.o)) \
	$(addprefix $(OBJ_DIR)/, $(S_SRC:.s=.o))


all: $(NAME)

$(NAME): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s | $(OBJ_DIR)
	$(AS) $(ASFLAGS) -o $@ $<

$(OBJ_DIR):
	mkdir -p $@

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -rf $(NAME)

re: fclean
	$(MAKE)
