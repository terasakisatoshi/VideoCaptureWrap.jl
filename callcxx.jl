# demo script


using ArgParse
using CxxWrap
using ImageCore

import VideoCaptureWrap

function cli()
    cap = VideoCaptureWrap.VideoCapture(0)

    if VideoCaptureWrap.isOpened(cap)
        W = Int(VideoCaptureWrap.get_capture_width(cap))
        H = Int(VideoCaptureWrap.get_capture_height(cap))
        while true
            jlimg = zeros(UInt8, 3 * H * W)
            VideoCaptureWrap.set_image!(jlimg, cap)
            jlimg = reshape(jlimg, 3, H, W)
            ImageInTerminal.imshow(colorview(RGB, normedview(jlimg)))
        end
        VideoCaptureWrap.release(cap)
    end
end

function gui()
    cap =  VideoCaptureWrap.VideoCapture(0)
    if VideoCaptureWrap.isOpened(cap)
        WINDOW_AUTOSIZE = 0x00000001
        VideoCaptureWrap.namedWindow("cvwindow", WINDOW_AUTOSIZE);
        W = Int(VideoCaptureWrap.get_capture_width(cap))
        H = Int(VideoCaptureWrap.get_capture_height(cap))
        CV_8U = 16
        cvimg = VideoCaptureWrap.Mat(H, W, CV_8U)
        while true
            cvimg = VideoCaptureWrap.read!(cap, cvimg)
            VideoCaptureWrap.imshow("cvwindow", cvimg)
            if VideoCaptureWrap.waitKey(1) & 0xFF == Int32('q')
                VideoCaptureWrap.destroyWindow("cvwindow")
                @info "break"
                break
            end
        end

        VideoCaptureWrap.release(cap)
    end
end

function main(mode::AbstractString)
    if args["mode"] == "cli"
        cli()
    end
    if args["mode"] == "gui"
        gui()
    else
        error("Invalid argument expected `cli` of `gui`")
    end
end

function parse_arguments()
    s = ArgParseSettings()
    @add_arg_table! s begin
        "mode"
            help = "whether display image result on Terminal(type `cli`) or OpenCV's GUI (type `gui`)"
            required = true
    end
    return parse_args(s)
end

args = parse_arguments()

if args["mode"] == "cli"
    @eval begin 
        using ImageInTerminal
        ImageInTerminal.use_24bit()
    end
end

main(args["mode"])