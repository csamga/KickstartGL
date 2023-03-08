BIN_PREFIX = bin
EXEC = $(BIN_PREFIX)/program

SRC_PREFIX = src
BUILD_PREFIX = build

SRCS = $(wildcard $(SRC_PREFIX)/*.c)
OBJS = $(patsubst $(SRC_PREFIX)/%.c,$(BUILD_PREFIX)/%.o,$(SRCS))

GLFW_DIR = external/glfw

INCLUDES = -I$(GLFW_DIR)/include

CC = gcc
CPPFLAGS = $(INCLUDES)
CFLAGS = -Wall -Wextra -Wpedantic

all: $(EXEC)

$(EXEC): $(OBJS)
	@echo "$(GREEN)Linking $^ for $@$(RESET)"
	mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@

$(BUILD_PREFIX)/%.o: $(SRC_PREFIX)/%.c
	@echo "$(GREEN)Compiling $<$(RESET)"
	mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

run: $(EXEC)
	@echo "$(GREEN)Running $<$(RESET)"
	./$(EXEC)

clean:
	@echo "$(GREEN)Cleaning$(RESET)"
	$(RM) -rf $(BIN_PREFIX)
	$(RM) -rf $(BUILD_PREFIX)

GREEN = \033[1;92m
RESET = \033[0m
