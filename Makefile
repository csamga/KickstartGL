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

GLEW_DIR = external/glew-cmake
GLEW_LIB_DIR = $(GLEW_DIR)/lib

CGLM_DIR = external/cglm
CGLM_BUILD_DIR = $(CGLM_DIR)/build
CGLM = $(CGLM_BUILD_DIR)/libcglm.a

GLFW_INCLUDE_DIR = $(GLFW_DIR)/include
GLEW_INCLUDE_DIR = $(GLEW_DIR)/include
CGLM_INCLUDE_DIR = $(CGLM_DIR)/include
INCLUDES = -I$(GLFW_INCLUDE_DIR) -I$(GLEW_INCLUDE_DIR) -I$(CGLM_INCLUDE_DIR)

CC = gcc
CPPFLAGS = $(INCLUDES) -DGLEW_STATIC -DGLEW_NO_GLU
CFLAGS = -Wall -Wextra -Wpedantic

LDFLAGS = -L$(GLFW_BUILD_DIR)/src -L$(GLEW_LIB_DIR) -L$(CGLM_BUILD_DIR)

ifeq ($(OS),Windows_NT)
	OS = windows
else
	UNAME := $(shell uname -s)
	ifeq ($(UNAME),Linux)
		OS = linux
	else
		@echo "$(RED)Platform not supported$(RESET)"
	endif
endif

ifeq ($(OS),windows)
	LDLIBS := -lglew32 -lglfw3 -lopengl32 -lgdi32 -lcglm
	GLEW := $(GLEW_LIB_DIR)/libglew32.a
else ifeq ($(OS),linux)
	LDLIBS := -lGLEW -lglfw3 -lGL -lm -lcglm
	GLEW := $(GLEW_LIB_DIR)/libGLEW.a
endif

all: $(EXEC)
.PHONY: all

$(EXEC): $(OBJS) $(GLFW) $(GLEW) $(CGLM)
	@echo "$(GREEN)Linking $^ for $@$(RESET)"
	mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBS)

$(BUILD_PREFIX)/%.o: $(SRC_PREFIX)/%.c
	@echo "$(GREEN)Compiling $<$(RESET)"
	mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(GLFW):
	@echo "$(GREEN)Building GLFW$(RESET)"
	mkdir -p $(@D)
	cmake -S $(GLFW_DIR) -B $(GLFW_BUILD_DIR) \
		-D GLFW_BUILD_EXAMPLES=OFF \
		-D GLFW_BUILD_DOCS=OFF \
		-D GLFW_BUILD_TESTS=OFF \
		-G "Unix Makefiles"
	$(MAKE) --directory=$(GLFW_BUILD_DIR)

$(GLEW):
	@echo "$(GREEN)Building GLEW$(RESET)"
	$(MAKE) glew.lib.static --directory=$(GLEW_DIR)

$(CGLM):
	@echo "$(GREEN)Building CGLM$(RESET)"
	mkdir -p $(@D)
	cmake -S $(CGLM_DIR) -B $(CGLM_BUILD_DIR) \
		-D CGLM_SHARED=OFF \
		-D CGLM_USE_C99=ON \
		-G "Unix Makefiles"
	$(MAKE) --directory=$(CGLM_BUILD_DIR)

glfw: $(GLFW)
.PHONY: glfw

glew: $(GLEW)
.PHONY: glew

cglm: $(CGLM)
.PHONY: cglm

run: $(EXEC)
	@echo "$(GREEN)Running $<$(RESET)"
	./$(EXEC)
.PHONY: run

clean:
	@echo "$(GREEN)Cleaning$(RESET)"
	$(RM) -rf $(BIN_PREFIX)
	$(RM) -rf $(BUILD_PREFIX)
.PHONY: clean

clean.glfw:
	@echo "$(GREEN)Cleaning GLFW$(RESET)"
	$(MAKE) clean --directory=$(GLFW_BUILD_DIR)
.PHONY: clean.glfw

clean.glew:
	@echo "$(GREEN)Cleaning GLEW$(RESET)"
	$(MAKE) clean --directory=$(GLEW_DIR)
.PHONY: clean.glew

clean.cglm:
	@echo "$(GREEN)Cleaning CGLM$(RESET)"
	$(MAKE) clean --directory=$(CGLM_BUILD_DIR)
.PHONY: clean.cglm

clean.libs: clean.glfw clean.glew clean.cglm
.PHONY: clean.libs

print-vars:
	@echo $(OS)
	@echo $(LDLIBS)

RED = \033[1;91m
GREEN = \033[1;92m
RESET = \033[0m
