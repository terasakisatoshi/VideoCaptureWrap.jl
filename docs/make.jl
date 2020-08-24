using VideoCaptureWrap
using Documenter

makedocs(;
    modules=[VideoCaptureWrap],
    authors="Satoshi Terasaki <terasakisatoshi.math@gmail.com> and contributors",
    repo="https://github.com/terasakisatoshi/VideoCaptureWrap.jl/blob/{commit}{path}#L{line}",
    sitename="VideoCaptureWrap.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://terasakisatoshi.github.io/VideoCaptureWrap.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/terasakisatoshi/VideoCaptureWrap.jl",
)
