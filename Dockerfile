FROM julia:1.5.0

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libeigen3-dev \
    libopencv-dev \
    cmake

RUN julia -e 'using Pkg; \
			  Pkg.add(["CxxWrap", "Revise", "OhMyREPL"]); \
			  Pkg.precompile()'

ENV LIB_CXXWRAP=./libcxxwrap-julia
RUN git clone https://github.com/JuliaInterop/libcxxwrap-julia.git && \
    cmake -DJulia_EXECUTABLE=`which julia` -S ${LIB_CXXWRAP} -B ${LIB_CXXWRAP}-build && \
    cmake --build ${LIB_CXXWRAP}-build --config Release -j ${nproc} && \
    cmake --build ${LIB_CXXWRAP}-build --target install

COPY Project.toml /work/Project.toml
COPY src/CxxProject.jl /work/src/CxxProject.jl
ENV JULIA_PROJECT=/work
RUN julia --project=/work -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()' && \
    rm -r /work/src
