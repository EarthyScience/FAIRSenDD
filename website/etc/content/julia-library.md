# Julia Library


The underlying algorithm of the FAIRSenDD workflow is implemented in the
Julia package
[RQADeforestation.jl](https://github.com/EarthyScience/RQADeforestation.jl).
Documentation about the individual methods are shown
[here](https://earthyscience.github.io/RQADeforestation.jl/dev/).

## Installation

Install the Julia library:

``` julia
using Pkg
Pkg.add(url="https://github.com/EarthyScience/RQADeforestation.jl.git")
```

## Mock data set

Compute the RQA trend metric of a mock data:

``` julia
using RQADeforestation
using Dates
using DimensionalData: Ti, X, Y
using Statistics
using YAXArrays
import Random

Random.seed!(1337)
mock_axes = (
    Ti(Date("2022-01-01"):Day(1):Date("2022-01-30")),
    X(range(1, 10, length=10)),
    Y(range(1, 5, length=15)),
)

mock_data = rand(30, 10, 15)
mock_props = Dict()
mock_cube = YAXArray(mock_axes, mock_data, mock_props)
mock_trend = rqatrend(mock_cube; thresh=0.5)
mock_trend
```

    [ Info: new driver key :gdal, updating backendlist.
    [ Info: new driver key :zarr, updating backendlist.

    outpath = "/tmp/jl_GruhmDIbSP.zarr"

    [ Info: new driver key :netcdf, updating backendlist.

    ┌ 10×15 YAXArray{Union{Missing, Float32}, 2} ┐
    ├────────────────────────────────────────────┴─────────────────────────── dims ┐
      ↓ X Sampled{Float64} 1.0:1.0:10.0 ForwardOrdered Regular Points,
      → Y Sampled{Float64} 1.0:0.2857142857142857:5.0 ForwardOrdered Regular Points
    ├──────────────────────────────────────────────────────────────────── metadata ┤
      Dict{String, Any} with 1 entry:
      "missing_value" => 1.0f32
    ├─────────────────────────────────────────────────────────────── loaded lazily ┤
      data size: 600.0 bytes
    └──────────────────────────────────────────────────────────────────────────────┘

View the results:

``` julia
using GLMakie
heatmap(mock_trend)
```

    ┌ Warning: Found `resolution` in the theme when creating a `Scene`. The `resolution` keyword for `Scene`s and `Figure`s has been deprecated. Use `Figure(; size = ...` or `Scene(; size = ...)` instead, which better reflects that this is a unitless size and not a pixel resolution. The key could also come from `set_theme!` calls or related theming functions.
    └ @ Makie ~/.julia/packages/Makie/ux0Te/src/scenes.jl:238

![](julia-library_files/figure-commonmark/cell-4-output-2.png)

## Real world data set

This example is using Sentinel-1 Sigma Nought backscatter data as
processed using [Wagner et
al. 2021](https://www.mdpi.com/2072-4292/13/22/4622) in [Equi7Grid
projection](https://github.com/TUW-GEO/Equi7Grid). Similar world wide
data can be accessed via the [EODC STAC
catalog](https://services.eodc.eu/browser/#/v1/collections/SENTINEL1_SIG0_20M).
The following test dataset contains only a subset of a tile to make it
faster to process.

Download some test data:

``` julia
using Downloads
using ZipFile

function unzip(file,exdir="")
    fileFullPath = isabspath(file) ?  file : joinpath(pwd(),file)
    basePath = dirname(fileFullPath)
    outPath = (exdir == "" ? basePath : (isabspath(exdir) ? exdir : joinpath(pwd(),exdir)))
    isdir(outPath) ? "" : mkdir(outPath)
    zarchive = ZipFile.Reader(fileFullPath)
    for f in zarchive.files
        fullFilePath = joinpath(outPath,f.name)
        if (endswith(f.name,"/") || endswith(f.name,"\\"))
            mkdir(fullFilePath)
        else
            write(fullFilePath, read(f))
        end
    end
    close(zarchive)
end

url = "https://github.com/meggart/RQADeforestationTestData/archive/refs/tags/v2.0.zip"
tmp_dir = mktempdir()
zip_path = joinpath(tmp_dir, "downloaded.zip")
Downloads.download(url, zip_path)
unzip(zip_path)

in_dir = joinpath(tmp_dir, "RQADeforestationTestData-2.0")
```

    "/tmp/jl_0A4vck/RQADeforestationTestData-2.0"

Run the workflow:

``` julia
using RQADeforestation

out_dir = joinpath(tmp_dir, "out")
using Zarr
using YAXArrays
using Dates
RQADeforestation.main(;
    tiles=["E051N018T3"],
    continent="EU",
    indir=in_dir,
    start_date=Date("2021-01-01"),
    end_date=Date("2022-01-01"),
    outdir=out_dir
)
```

    [ Info: Write output to /tmp/jl_0A4vck/out

    relorbits = SubString{String}["022"]
    length(dates) = 184
      3.686054 seconds (12.34 M allocations: 620.074 MiB, 3.72% gc time, 99.42% compilation time: 1% of which was recompilation)
    path = "/tmp/jl_0A4vck/out/E051N018T3_rqatrend_VH_D022_thresh_3.0"
    size(cube) = (50, 74, 61)
    size(tcube) = (50, 74, 48)
    outpath = "/tmp/jl_0A4vck/out/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr"
      4.594161 seconds (18.12 M allocations: 919.508 MiB, 16.99% gc time, 85.62% compilation time)

The directory `out_dir` forms a [Zarr
Dataset](https://zarr.dev/datasets/) that can be opened as an n
dimensional array in various ways,
e.g. [xarray](https://docs.xarray.dev/en/stable/) in Pxthon and
[YAXArrays](https://juliadatacubes.github.io/YAXArrays.jl/stable/) in
Julia.

Examine the output data cube using YAXArrays:

``` julia
a = open_dataset(out_dir * "/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr").layer
a
```

    ┌ 50×74 YAXArray{Union{Missing, Float32}, 2} ┐
    ├────────────────────────────────────────────┴─────────────────────────── dims ┐
      ↓ X Sampled{Float64} 5.255e6:20.0:5.25598e6 ForwardOrdered Regular Points,
      → Y Sampled{Float64} 2.03299e6:-20.0:2.03153e6 ReverseOrdered Regular Points
    ├──────────────────────────────────────────────────────────────────── metadata ┤
      Dict{String, Any} with 3 entries:
      "missing_value" => 1.0e32
      "name"          => "layer"
      "_FillValue"    => 1.0f32
    ├─────────────────────────────────────────────────────────────── loaded lazily ┤
      data size: 14.45 KB
    └──────────────────────────────────────────────────────────────────────────────┘

Plot the output data cube:

``` julia
using GLMakie
heatmap(a)
```

    ┌ Warning: Found `resolution` in the theme when creating a `Scene`. The `resolution` keyword for `Scene`s and `Figure`s has been deprecated. Use `Figure(; size = ...` or `Scene(; size = ...)` instead, which better reflects that this is a unitless size and not a pixel resolution. The key could also come from `set_theme!` calls or related theming functions.
    └ @ Makie ~/.julia/packages/Makie/ux0Te/src/scenes.jl:238

![](julia-library_files/figure-commonmark/cell-8-output-2.png)
