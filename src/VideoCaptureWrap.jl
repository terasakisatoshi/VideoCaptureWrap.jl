module VideoCaptureWrap

using CxxWrap
using VideoCaptureWrap_jll
const libvideocapture = VideoCaptureWrap_jll.libvideocapture_path
isfile(libvideocapture) && @wrapmodule(libvideocapture, :define_videoio_module)

function __init__()
    @initcxx
end

end
