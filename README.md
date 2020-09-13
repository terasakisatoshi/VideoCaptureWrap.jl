# VideoCaptureWrap

<!-- [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://terasakisatoshi.github.io/VideoCaptureWrap.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://terasakisatoshi.github.io/VideoCaptureWrap.jl/dev) -->

# News!

- We've succeeded to display video frames using OpenCV's API namely `cv::imshow`. Just try:

```
$ make gui # or make run gui
```

# About this repository

- This repository provides an example of how to wrap OpenCV API via [CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl).
It also demonstrates a demo that capture image from your Web/USB camera and display its result using [ImageInTerminal.jl](https://github.com/JuliaImages/ImageInTerminal.jl) or OpenCV's API.

- It is tested on Ubuntu 18.04 or Mac(Catalina) with `Julia v1.5.1` . The latter has the following environment:

```julia
                 _
     _       _ _(_)_     |  Documentation: https://docs.julialang.org
    (_)     | (_) (_)    |
     _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
    | | | | | | |/ _` |  |
    | | |_| | | | (_| |  |  Version 1.5.1 (2020-08-25)
   _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
  |__/                   |

  julia> versioninfo()
  Julia Version 1.5.1
  Commit 697e782ab8 (2020-08-25 20:08 UTC)
  Platform Info:
    OS: macOS (x86_64-apple-darwin19.5.0)
    CPU: Intel(R) Core(TM) i9-9900K CPU @ 3.60GHz
    WORD_SIZE: 64
    LIBM: libopenlibm
    LLVM: libLLVM-9.0.1 (ORCJIT, skylake)
  Environment:
    JULIA_EDITOR = subl
    JULIA_NUM_THREADS = 16
    JULIA_PROJECT = @.
```

# Usage

## Install dependencies

- Download Julia 1.5 from [here](https://julialang.org/downloads/).
- Install Make, CMake (to run `make` or `cmake`)
- Install OpenCV e.g. `brew install opencv`, `apt-get install libopencv-dev` you know what to do.
- If you are Mac user, install iterm2 to run our application with it.

## Let's Run!!!

- Clone this repository and run `make` command. That's is O.K. Do not think, just feel it.

```console
$ git clone https://github.com/terasakisatoshi/VideoCaptureWrap.jl.git
$ cd VideoCaptureWrap.jl
$ make
# Start building ... and running our application .
# (See callcxx.jl, videocapture.cpp and src/VideoCaptureWrap.jl to see more details)
```

- You can also try:

```console
$ make run cli
$ make run gui
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
