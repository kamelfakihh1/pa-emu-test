CC = /home/kamel/cybersecurity-project/llvm-project/build/bin/clang++ 
LD = /home/kamel/cybersecurity-project/llvm-project/build/bin/ld.lld
AR = /home/kamel/cybersecurity-project/llvm-project/build/bin/llvm-ar

CFLAGS     = --target=aarch64-linux-gnu --sysroot=$(HOME)/cybersecurity-project/qemu-arm64-machine/debian/aarch64-sysroot/
INC_FLAGS  = -I./include -I/home/kamel/cybersecurity-project/qarma64/include
LIB_FLAGS  = -L/home/kamel/cybersecurity-project/qarma64/build/lib/ -lQarma64
LDFLAGS    = 
# LDFLAGS    = -Wall -Os -Wl 	-Map

SRC_DIR   = ./src
BUILD_DIR = ./build
OBJS_DIR  = $(BUILD_DIR)/objs
BIN_DIR   = $(BUILD_DIR)/bin

TARGET    = program

SRC_FILES     = $(wildcard $(SRC_DIR)/*.cpp)
OBJ_FILES     = $(patsubst $(SRC_DIR)/%.cpp, $(OBJS_DIR)/%.o, $(SRC_FILES))
DEPENDENCIES  = $(OBJ_FILES:.o=.d)

.PHONY: all info clean

all : $(BIN_DIR)/$(TARGET)

# Build rules
$(BIN_DIR)/$(TARGET): $(OBJ_FILES)
	@mkdir -p $(BIN_DIR)	
	$(CC) $(CFLAGS) $(LIB_FLAGS) $(INC_FLAGS) -fuse-ld=lld -o $@ $^


$(OBJS_DIR)/%.o: $(SRC_DIR)/%.cpp
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