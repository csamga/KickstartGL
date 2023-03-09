BIN_PREFIX = bin
EXEC = $(BIN_PREFIX)/program

SRC_PREFIX = src
BUILD_PREFIX = build

SRCS = $(wildcard $(SRC_PREFIX)/*.c)
OBJS = $(patsubst $(SRC_PREFIX)/%.c,$(BUILD_PREFIX)/%.o,$(SRCS))

GLFW_DIR = external/glfw
GLFW_BUILD_DIR = $(GLFW_DIR)/build
GLFW_LIB_DIR = $(GLFW_BUILD_DIR)/src
GLFW = $(GLFW_LIB_DIR)/libglfw3.a

GLFW_INCLUDE_DIR = $(GLFW_DIR)/include
INCLUDES = -I$(GLFW_INCLUDE_DIR)

CC = gcc
CPPFLAGS = $(INCLUDES)
CFLAGS = -Wall -Wextra -Wpedantic

LDFLAGS = -L$(GLFW_BUILD_DIR)/src
LDLIBS = -lGL -lglfw3 -lm

all: $(EXEC)
.PHONY: all

$(EXEC): $(OBJS) $(GLFW)
	@echo "$(GREEN)Linking $^ for $@$(RESET)"
	mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBS)

$(BUILD_PREFIX)/%.o: $(SRC_PREFIX)/%.c
	@echo "$(GREEN)Compiling $<$(RESET)"
	mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

glfw: $(GLFW)
$(GLFW):
	@echo "$(GREEN)Building GLFW$(RESET)"
	mkdir -p $(@D)
	cmake -S $(GLFW_DIR) -B $(GLFW_BUILD_DIR) \
		-D GLFW_BUILD_EXAMPLES=0FF \
		-D GLFW_BUILD_DOCS=OFF \
		-D GLFW_BUILD_TESTS=OFF
	cd $(GLFW_BUILD_DIR) && $(MAKE)

run: $(EXEC)
	@echo "$(GREEN)Running $<$(RESET)"
	./$(EXEC)
.PHONY: run

clean:
	@echo "$(GREEN)Cleaning$(RESET)"
	$(RM) -rf $(BIN_PREFIX)
	$(RM) -rf $(BUILD_PREFIX)
.PHONY: clean

GREEN = \033[1;92m
RESET = \033[0m
