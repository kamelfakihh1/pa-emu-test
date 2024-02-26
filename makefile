LLVM_BIN ?= /change/to/llvm/bin/path
SYSROOT_DIR ?= /change/to/aarch64-linux-gnu/sysroot/directory
QARMA64_LIB ?= /change/to/qarma64/lib/path

CC = $(LLVM_BIN)/clang++ 
LD = $(LLVM_BIN)/clang++
AR = $(LLVM_BIN)/llvm-ar

CFLAGS     = --target=aarch64-linux-gnu --sysroot=$(SYSROOT_DIR) 
INC_FLAGS  = -I./include -I$(QARMA64_LIB)/../include
LIB_FLAGS  = -L$(QARMA64_LIB) -lQarma64
LDFLAGS    = 
# LDFLAGS    = -Wall -Os -Wl 	-Map

SRC_DIR   = ./src
BUILD_DIR = ./build
OBJS_DIR  = $(BUILD_DIR)/objs
BIN_DIR   = $(BUILD_DIR)/bin

PROTECTED   = program_protected
UNPROTECTED = program_unprotected 

SRC_FILES     = $(wildcard $(SRC_DIR)/*.cpp)
PROTECTED_OBJ_FILES       = $(patsubst $(SRC_DIR)/%.cpp, $(OBJS_DIR)/protected/%.o, $(SRC_FILES))
UNPROTECTED_OBJ_FILES     = $(patsubst $(SRC_DIR)/%.cpp, $(OBJS_DIR)/unprotected/%.o, $(SRC_FILES))
DEPENDENCIES  = $(OBJ_FILES:.o=.d)

.PHONY: all info clean

all : $(BIN_DIR)/$(PROTECTED) $(BIN_DIR)/$(UNPROTECTED)

# Build rules
$(BIN_DIR)/$(PROTECTED): $(PROTECTED_OBJ_FILES)
	@mkdir -p $(BIN_DIR)	
	$(CC) $(CFLAGS) $(LIB_FLAGS) $(INC_FLAGS) -fuse-ld=lld -o $@ $^		

$(BIN_DIR)/$(UNPROTECTED): $(UNPROTECTED_OBJ_FILES)
	@mkdir -p $(BIN_DIR)	
	$(CC) $(CFLAGS) $(LIB_FLAGS) $(INC_FLAGS) -fuse-ld=lld -o $@ $^	

$(OBJS_DIR)/protected/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(@D)	
	$(CC) $(CFLAGS) $(INC_FLAGS) -mllvm -pa-emu -c -o $@ $< 

$(OBJS_DIR)/unprotected/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(@D)	
	$(CC) $(CFLAGS) $(INC_FLAGS) -c -o $@ $< 

info: 
	$(info $(SRC_FILES))
	$(info $(OBJ_FILES))
	$(info $(DEPENDENCIES))
	$(info $(BIN_DIR)/$(TARGET))

# Clean
clean:
	$(RM) -r $(BUILD_DIR)

-include $(DEPENDENCIES)