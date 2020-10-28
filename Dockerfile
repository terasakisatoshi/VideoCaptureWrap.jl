FROM julia:1.5.2

# Tip1: https://askubuntu.com/questions/342202/failed-to-load-module-canberra-gtk-module-but-already-installed

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libeigen3-dev \
    libopencv-dev \
    libstdc++6 \
    cmake \
    libcanberra-gtk-module libcanberra-gtk3-module # Tip1 \
    && \
    echo "Done"

RUN julia -e 'using Pkg; Pkg.add(["ArgParse", "CxxWrap", "ImageCore", "Images", "ImageInTerminal", "Libdl"]); Pkg.precompile()'


ENV LIB_CXXWRAP=./libcxxwrap-julia
RUN git clone https://github.com/JuliaInterop/libcxxwrap-julia.git && \
    cmake -DJulia_EXECUTABLE=`which julia` -S ${LIB_CXXWRAP} -B ${LIB_CXXWRAP}-build && \
    cmake --build ${LIB_CXXWRAP}-build --config Release -j ${nproc} && \
    cmake --build ${LIB_CXXWRAP}-build --target install

# hack GLIBCXX_3.4.** problem
RUN cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/local/julia/lib/julia/

