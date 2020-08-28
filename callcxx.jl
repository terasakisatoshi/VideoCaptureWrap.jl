# demo script

using CxxWrap
using ImageInTerminal
using ImageCore

import VideoCaptureWrap

function demo()
    cap =  VideoCaptureWrap.VideoCapture(0)

    if VideoCaptureWrap.isOpened(cap)
        W= Int(VideoCaptureWrap.get_capture_width(cap))
        H= Int(VideoCaptureWrap.get_capture_height(cap))
        while(true)
            jlimg= zeros(UInt8, 3*H*W)
            VideoCaptureWrap.set_image!(jlimg, cap)
            jlimg = reshape(jlimg, 3, H, W)
            ImageInTerminal.imshow(colorview(RGB, normedview(jlimg)))
        end
        VideoCaptureWrap.release(cap)
    end
end

demo()