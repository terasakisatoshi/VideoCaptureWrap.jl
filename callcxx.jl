# demo script


using ArgParse
using CxxWrap
using ImageCore
using ImageTransformations

import VideoCaptureWrap

function cli()
    cap = VideoCaptureWrap.VideoCapture(0)

    if VideoCaptureWrap.isOpened(cap)
        W = Int(VideoCaptureWrap.get_capture_width(cap))
        H = Int(VideoCaptureWrap.get_capture_height(cap))
        C = 3
        CV_8U = 16
        cvimg = VideoCaptureWrap.Mat(H, W, CV_8U)
        jlimg = zeros(UInt8, C * H * W)
        while true
            VideoCaptureWrap.read!(cap, cvimg)
            VideoCaptureWrap.set_jlimage!(jlimg, cvimg)
            ImageInTerminal.imshow(
                colorview(
                    RGB, 
                    normedview(reshape(jlimg, C, H, W))
                )
            )
        end
        VideoCaptureWrap.release(cap)
    end
end

update_degree_mac(degree) = mod(degree + 1, 360)
update_degree_linux(degree) = 45

update_degree = @static Sys.isapple() ? update_degree_mac : update_degree_linux

function gui()
    cap =  VideoCaptureWrap.VideoCapture(0)
    if VideoCaptureWrap.isOpened(cap)
        WINDOW_AUTOSIZE = 0x00000001
        VideoCaptureWrap.namedWindow("cvwindow", WINDOW_AUTOSIZE);
        W = Int(VideoCaptureWrap.get_capture_width(cap))
        H = Int(VideoCaptureWrap.get_capture_height(cap))
        C = 3
        CV_8U = 16
        cvimg = VideoCaptureWrap.Mat(H, W, CV_8U)
        jlimg = zeros(UInt8, C * H * W)
        degree = 0
        @info "press q to quit"
        while true
            VideoCaptureWrap.read!(cap, cvimg)
            VideoCaptureWrap.set_jlimage!(jlimg, cvimg)
            degree = update_degree(degree)
            rotated = imrotate(colorview(
                        RGB, 
                        normedview(reshape(jlimg, C, H, W))
                    ), 
                    degree |> deg2rad,
            ) |> channelview |> rawview .|> UInt8
            cvimg_imshow = VideoCaptureWrap.to_cvimage(vec(rotated), size(rotated)...)
            VideoCaptureWrap.imshow("cvwindow", cvimg_imshow)
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