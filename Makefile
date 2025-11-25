# Detect operating system
ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
    RM = del /Q
    RMDIR = rmdir /S /Q
    MKDIR = if not exist "$(1)" mkdir "$(1)"
    PATHSEP = \\
else
    DETECTED_OS := $(shell uname -s)
    RM = rm -f
    RMDIR = rm -rf
    MKDIR = mkdir -p $(1)
    PATHSEP = /
endif

# Project name
PROJECT = instrumentor

# Compiler and linker
CC = lcc
LCC = lcc

# Directories
BUILD_DIR = build
DIST_DIR = dist

# Source files
SOURCES = instrument1.c font.c
OBJECTS = $(addprefix $(BUILD_DIR)/, $(SOURCES:.c=.o))

# Output file
ROM = $(DIST_DIR)/$(PROJECT).gb

# Compiler flags
CFLAGS = -Wa-l -c

# Linker flags
LDFLAGS = -Wl-m -Wl-j -Wm-yc

# Default target
all: directories $(ROM)


# Create output directories
directories:
ifeq ($(DETECTED_OS),Windows)
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
	@if not exist "$(DIST_DIR)" mkdir "$(DIST_DIR)"
else
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(DIST_DIR)
endif

# Link object files to create ROM
$(ROM): $(OBJECTS)
	@echo Linking...
	$(LCC) $(LDFLAGS) -o $@ $^
	@echo
	@echo Build successful! $(ROM)

# Compile C source files to object files
$(BUILD_DIR)/%.o: %.c
	@echo Compiling $<...
	$(CC) $(CFLAGS) -o $@ $<


# Clean build artifacts
clean:
	@echo Cleaning build artifacts...
ifeq ($(DETECTED_OS),Windows)
	@if exist "$(BUILD_DIR)" $(RMDIR) "$(BUILD_DIR)"
	@if exist "$(DIST_DIR)" $(RMDIR) "$(DIST_DIR)"
else
	@$(RMDIR) $(BUILD_DIR) $(DIST_DIR)
endif


# Help target
help:
	@echo GameBoy Instrumentor Makefile
	@echo
	@echo Detected OS: $(DETECTED_OS)
	@echo
	@echo Targets:
	@echo   all "("default")" - Build the ROM
	@echo   clean         - Remove all generated files and directories
	@echo   help          - Show this help message

.PHONY: all directories clean run help

