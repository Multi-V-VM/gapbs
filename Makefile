# See LICENSE.txt for license details.

# CXX_FLAGS += -std=c++11 -O3 -Wall -Iposix -I. -DFLAGS_STR=\""-O3 -DPERFORMANCE_RUN=1"\"  -Wl,--export=main  -DITERATIONS=0 -DPERFORMANCE_RUN=1  -Wl,--allow-undefined 
CXX_FLAGS += -std=c++11 -O3 -Wall -s STANDALONE_WASM=1 -s INITIAL_MEMORY=1048576 -s TOTAL_STACK=32768 -s "EXPORTED_FUNCTIONS=['_main']" -s ERROR_ON_UNDEFINED_SYMBOLS=0
# PAR_FLAG = -fopenmp
PAR_FLAG = 

ifneq (,$(findstring icpc,$(CXX)))
	PAR_FLAG = -openmp
endif

ifneq (,$(findstring sunCC,$(CXX)))
	CXX_FLAGS = -std=c++11 -xO3 -m64 -xtarget=native
	PAR_FLAG = -xopenmp
endif

ifneq ($(SERIAL), 1)
	CXX_FLAGS += $(PAR_FLAG)
endif

KERNELS = bc bfs cc cc_sv pr pr_spmv sssp tc
SUITE = $(KERNELS) converter

.PHONY: all
all: $(SUITE)

% : src/%.cc src/*.h
	$(CXX) $(CXX_FLAGS) $< -o $@

# Testing
include test/test.mk

# Benchmark Automation
include benchmark/bench.mk


.PHONY: clean
clean:
	rm -f $(SUITE) test/out/*
