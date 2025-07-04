MODULE_NAME = test_ulpi
MODULES_DIR := ../${MODULE_NAME}


ifeq (${MODULE_NAME}, test_ulpi)
	TOP_NAME := testbench_ulpi
	SRC_DIR := ${MODULES_DIR}
# Add any additional directories here
	SRC_DIRS = ${SRC_DIR} 
	SRC_FILE := $(shell find $(SRC_DIRS) -name '*.vh') $(shell find $(SRC_DIRS) -name '*.svh') \
				$(shell find $(SRC_DIRS) -name '*.v') $(shell find $(SRC_DIRS) -name '*.sv') \

else ifeq (${MODULE_NAME}, )
    CPP_FILE = sim_main_simple.cpp
else
    CPP_FILE = INVALID_TOP_NAME
endif


# Verilator options
VERILATOR_OPTS = -cc \
    -Wno-NULLPORT \
    -Wno-COMBDLY \
    -Wno-PINMISSING \
    -Wno-MODDUP \
    -Wno-UNOPTFLAT \
    --exe \
    --trace \
    --trace-structs \
    --build \
    --timing

 # Make sure to unset this warning when first compiling + check warnings
 # -Wno-UNOPTFLAT

.PHONY: run clean

# target (binary name) : dependencies
obj_dir/V$(TOP_NAME): ${SRC_DIR}/* $(SRC_FILE)
	verilator $(VERILATOR_OPTS) ${CPP_FILE} $(SRC_FILE) -I$(SRC_DIR) --top $(TOP_NAME) -j `nproc`
# verilator	-cc	-Wno-NULLPORT	-Wno-COMBDLY	-Wno-PINMISSING	-Wno-MODDUP	--exe	--trace	--trace-structs	--build	--timing	src/sim_main.cpp	$(SRC_FILE)	-I$(SRC_DIR)	--top	$(TOP_NAME)	-j	`nproc`

run: obj_dir/V$(TOP_NAME)
	./obj_dir/V$(TOP_NAME)

print_sources:
	echo ${SRC_FILE}

clean:
	rm -rf obj_dir