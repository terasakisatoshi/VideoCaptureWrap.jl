NPROCS:=1
OS:=$(shell uname -s)

ifeq ($(OS),Linux)
  NPROCS:=$(shell grep -c ^processor /proc/cpuinfo)
endif
ifeq ($(OS),Darwin) # Assume Mac OS X
  NPROCS:=$(shell getconf _NPROCESSORS_ONLN)
endif

# https://stackoverflow.com/questions/2214575/passing-arguments-to-make-run
# If the first argument is "run"...
ifeq (run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.phony: all, build, run, clean, docker, cli, gui

all: cli

build: *.cpp CMakeLists.txt
	julia --project=. -e 'using Pkg; Pkg.instantiate()'
	cmake -S ./ -B ./build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=`julia --project=. -e 'using CxxWrap; CxxWrap.prefix_path() |> print'` && \
	cmake --build ./build --config Release -j ${NPROCS}

run: build
	julia --project=. callcxx.jl $(RUN_ARGS)

gui: build
	julia --project=. callcxx.jl gui

cli: build
	julia --project=. callcxx.jl cli

clean:
	rm -rf build
	rm -rf Manifest.toml