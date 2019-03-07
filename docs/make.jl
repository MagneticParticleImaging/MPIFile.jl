using Documenter, MPIFiles

makedocs(
    modules = [MPIFiles],
    format = :html,
    sitename = "Julia MPI Package",
    authors = "Tobias Knopp, et al.",
    pages = [
        "Home" => "index.md",
        "Getting Started" => "gettingStarted.md",
        "Low Level Interface" => "lowlevel.md",
        "Conversion" => "conversion.md",
        "Measurements" => "measurements.md",
        "System Matrix" => "systemmatrix.md",
        "Images" => "images.md",
        "Positions" => "positions.md"
    ],
    html_prettyurls = false, #!("local" in ARGS),
)

deploydocs(
    repo = "github.com/MagneticParticleImaging/MPIFiles.jl.git",
    target = "build",
)
