module VideoCaptureWrap

using CxxWrap
using VideoCaptureWrap_jll
const libvideocapture = VideoCaptureWrap_jll.libvideocapture_path

#= 
# For those who like to use your shared library
using Libdl
const libvideocapture = joinpath("build", "lib", "libvideocapture.$(Libdl.dlext)")
=#

isfile(libvideocapture) && @wrapmodule(libvideocapture, :define_videoio_module)

function __init__()
    @initcxx
end

end
