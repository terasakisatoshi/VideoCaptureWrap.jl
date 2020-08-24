module VideoCaptureWrap

const _ext = @static Sys.isapple() ? "dylib" : "so"

using CxxWrap
const libvideocapture = joinpath(@__DIR__, "..", "build", "lib", "libvideocapture.$(_ext)")
isfile(libvideocapture) && @wrapmodule(libvideocapture, :define_videoio_module)

function __init__()
    @initcxx
end

end
