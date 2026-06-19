NAME = libasm.a

TEST_NAME = libasm_test

CC = gcc

CFLAGS = -Wall -Wextra -Werror

AS = nasm

ASFLAGS = -f elf64

AR = ar

AR_FLAGS = rcs

SRC_DIR = src

C_SRC = $(SRC_DIR)/main.c

S_SRC = ft_hello_world.s ft_strlen.s ft_strcpy.s ft_strcmp.s ft_write.s ft_read.s ft_strdup.s

OBJ_DIR = obj

OBJ = $(addprefix $(OBJ_DIR)/, $(S_SRC:.s=.o))

all: $(NAME)

$(NAME): $(OBJ)
	$(AR) $(AR_FLAGS) $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s | $(OBJ_DIR)
	$(AS) $(ASFLAGS) -o $@ $<

$(OBJ_DIR):
	mkdir -p $@

test: all
	$(CC) $(CFLAGS) $(C_SRC) $(NAME) -o $(TEST_NAME)

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -rf $(NAME)
	rm -rf $(TEST_NAME)

re: fclean
	$(MAKE)

.PHONY: all clean fclean re test
