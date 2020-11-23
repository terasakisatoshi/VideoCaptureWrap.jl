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

.phony: all, install, build, run, clean, docker, cli, gui

all: cli

build: deps
	julia --project=deps/src -e 'using Pkg; Pkg.instantiate()'
	cmake -S ./deps/src -B ./build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=`julia --project=deps/src -e 'using CxxWrap; CxxWrap.prefix_path() |> print'` && \
	cmake --build ./build --config Release -j ${NPROCS}

install: 
	julia --project=. -e 'using Pkg; Pkg.add(PackageSpec(name="libcxxwrap_julia_jll", rev="libcxxwrap_julia-v0.8.4+0"))'
	julia --project=. -e 'using Pkg; pkg"add https://github.com/terasakisatoshi/OpenCVQt_jll.jl.git"'
	julia --project=. -e 'using Pkg; pkg"add https://github.com/terasakisatoshi/VideoCaptureWrap_jll.jl.git"'
	julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

run: install
	julia --project=. callcxx.jl $(RUN_ARGS)

gui: install
	julia --project=. callcxx.jl gui

cli: install
	julia --project=. callcxx.jl cli

clean:
	julia --project=. -e 'using Pkg; Pkg.rm(["libcxxwrap_julia_jll", "OpenCVQt_jll", "VideoCaptureWrap_jll"])'
	rm -rf ${HOME}/.julia/compiled/v1.5/VideoCaptureWrap
	rm -rf build
	rm -rf Manifest.toml
