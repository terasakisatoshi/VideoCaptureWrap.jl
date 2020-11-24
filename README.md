# VideoCaptureWrap

<!-- [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://terasakisatoshi.github.io/VideoCaptureWrap.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://terasakisatoshi.github.io/VideoCaptureWrap.jl/dev) -->

# News!

## v0.5.x

- We've created JLL Library [OpenCVQt_jll.jl](https://github.com/terasakisatoshi/OpenCVQt_jll.jl) and [VideoCaptureWrap_jll.jl](https://github.com/terasakisatoshi/VideoCaptureWrap_jll.jl), where
  - OpenCVQt_jll.jl provides OpenCV shared library. It enables us skip installation of OpenCV manually.
  - VideoCaptureWrap_jll.jl provides shared library named libvideocapture.[so, dll]. It enables us to skip build `videocapture.cpp` manually.
- Since BinaryBuilder.jl provides compilers for Windows platforms, we can provide/build our `videocapture.cpp` which means our application VideoCaptureWrap.jl runs on your Windows (64 bit system) machine.

- Copy the following commands on your terminal to test out our package.

```console
julia --project=. -e 'using Pkg; Pkg.add(PackageSpec(name="libcxxwrap_julia_jll", rev="libcxxwrap_julia-v0.8.4+0"))'
julia --project=. -e 'using Pkg; pkg"add https://github.com/terasakisatoshi/OpenCVQt_jll.jl.git"'
julia --project=. -e 'using Pkg; pkg"add https://github.com/terasakisatoshi/VideoCaptureWrap_jll.jl.git"'
julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'
julia --project=. callcxx.jl gui
```

# About this repository

- This repository provides an example of how to wrap OpenCV API via [CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl).
It also demonstrates a demo that capture image from your Web/USB camera and display its result using [ImageInTerminal.jl](https://github.com/JuliaImages/ImageInTerminal.jl) or OpenCV's API.

- It is tested on Ubuntu 18.04, macOS (Catalina), Windows (64-bit system) , Jetson nano (aarch64) and Raspberry Pi4 with (armv7l) `Julia v1.5.3`. 

# Usage

## Case1

Just run:

```console
$ julia --project=. -e 'using Pkg; Pkg.add(PackageSpec(name="libcxxwrap_julia_jll", rev="libcxxwrap_julia-v0.8.4+0"))'
$ julia --project=. -e 'using Pkg; pkg"add https://github.com/terasakisatoshi/OpenCVQt_jll.jl.git"'
$ julia --project=. -e 'using Pkg; pkg"add https://github.com/terasakisatoshi/VideoCaptureWrap_jll.jl.git"'
$ julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'
$ julia --project=. callcxx.jl gui
```

## Case2

- You can also try:

```console
$ make run cli
$ make run gui
```

## Case3

- For those who hasitates to install Julia but knows Docker, try `run.sh` script :D

```console
$ bash run.sh
```

Enjoy Julia!!!

# Appendix

## Build `videocapture.cpp` from source

- Here is a note for those who like to build our application.

### Case1 

- You can build cpp source files by your self

#### Install dependencies

- Download Julia 1.5 from [here](https://julialang.org/downloads/).
- Install Make, CMake (to run `make` or `cmake`)
- Install OpenCV e.g. `brew install opencv`, `apt-get install libopencv-dev` you know what to do.
- If you are macOS user, install iterm2 to run our application with it.

#### Build `libvideocapture`

- Clone this repository and run `make build` command.

```console
$ git clone https://github.com/terasakisatoshi/VideoCaptureWrap.jl.git
$ cd VideoCaptureWrap.jl
$ make build
# Start building ... and running our application .
# (See callcxx.jl, videocapture.cpp and src/VideoCaptureWrap.jl to see more details)
```

- open `src/VideoCaptureWrap.jl` and replace `const libvideocapture` variable with the following code:

```julia
using Libdl
const libvideocapture = joinpath("build", "lib", "libvideocapture.$(Libdl.dlext)")
```

### Case2 

- By using `BinaryBuilder.jl` you do not have to prepare C++ compiler by your e.g. on your Windows machine.

#### Install Dependencies

- Download Julia 1.5 from [here](https://julialang.org/downloads/).
- Install Docker
- Install BinaryBuilder.jl via 

```console
$ julia -e 'using Pkg; Pkg.add("BinaryBuilder")'
```
#### Build OpenCVQt_jll.jl

Just run:

```console
$ git clone https://github.com/terasakisatoshi/OpenCVBuilder.jl.git
$ cd OpenCVBuilder.jl/qt
$ julia build_tarball.jl --verbose --deploy=local
```

#### Build VideoCaptureWrap_jll.jl

Just run:

```console
$ git clone https://github.com/terasakisatoshi/VideoCaptureWrapBuilder.jl.git
$ cd VideoCaptureWrapBuilder.jl
$ julia build_tarball.jl --verbose --deploy=local
```

### Install JLL library

Finally

```console
$ julia -e 'using Pkg; pkg"add ~/.julia/dev/OpenCV_Jll"'
$ julia -e 'using Pkg; pkg"add ~/.julia/dev/VideoCaptureWrap_Jll"'
```

That's it. Try to run

```console
$ julia --project=. callcxx.jl gui 
```


# References

- [https://julialang.org/](https://julialang.org/)
- [https://opencv.org/](https://opencv.org/)
- [JuliaInterop/CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl)
- [JuliaInterop/libcxxwrap-julia](https://github.com/JuliaInterop/libcxxwrap-julia)
- [barche/cxxwrap-juliacon2020](https://github.com/barche/cxxwrap-juliacon2020)
- [TakekazuKATO/OpenCV.jl](https://github.com/TakekazuKATO/OpenCV.jl)
- [JuliaImages/ImageInTerminal.jl](https://github.com/JuliaImages/ImageInTerminal.jl)
- [JuliaImages/ImageCore.jl](https://github.com/JuliaImages/ImageCore.jl)
- [My gist1](https://gist.github.com/terasakisatoshi/b6a7121cd570f6739992345095b07d62)
- [My gist2](https://gist.github.com/terasakisatoshi/163ab1fc3ff1adab340d221eae33d218)
