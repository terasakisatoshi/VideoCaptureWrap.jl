NPROCS:=1
OS:=$(shell uname -s)

ifeq ($(OS),Linux)
  NPROCS:=$(shell grep -c ^processor /proc/cpuinfo)
endif
ifeq ($(OS),Darwin) # Assume Mac OS X
  NPROCS:=$(shell getconf _NPROCESSORS_ONLN)
endif

.phony: all, build, run, clean, docker

all: run

docker:
	docker build -t cxxwrap .
	docker run --rm -it -v ${PWD}:/work -w /work cxxwrap julia -e 'using Pkg; Pkg.instantiate()'

build: *.cpp CMakeLists.txt
	julia --project=. -e 'using Pkg; Pkg.instantiate()'
	cmake -S ./ -B ./build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=`julia --project=. -e 'using CxxWrap; CxxWrap.prefix_path() |> print'` && \
	cmake --build ./build --config Release -j ${NPROCS}

run: build
	julia --project=. callcxx.jl

clean:
	rm -rf build
	rm -rf Manifest.toml