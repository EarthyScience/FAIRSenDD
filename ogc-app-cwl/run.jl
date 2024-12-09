#!/usr/bin/env -S julia --color=yes --startup-file=no --project=. --threads=auto

using YAXArrays: YAXDefaults
using Glob: glob
using ArgParse
using RQADeforestation: gdalcube, rqatrend
using DimensionalData: (..)
using Dates: Date
using Distributed: addprocs, @everywhere

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--threshold", "-t"
        help = "Threshold for the recurrence matrix computation"
        default = 3.0

        "--polarisation", "-p"
        help = "Polarisation that should be stacked"
        default = "VH"

        "--year", "-y"
        help = "Year in which the RQA Trend should be detected. 
        We take a buffer of six month before and after the year to end up with two years of data."
        default = 2018
        arg_type = Int

        "--orbit", "-o"
        help = "One of: Orbit number, 'A' for ascending, 'D' for descending, '*' for all orbits"
        default = "*"

        "--out-dir", "-d"
        help = "Path to output zarr dataset"
        default = "out.zarr"

        "continent"
        help = "continent code for the tile to be processed"
        required = true

        "tile"
        help = "Tile id to be processed"
        required = true
    end

    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()

    pol = parsed_args["polarisation"]
    orbit = parsed_args["orbit"]
    thresh = parsed_args["threshold"]

    indir = "/eodc/products/eodc.eu/S1_CSAR_IWGRDH/SIG0/"
    outdir = parsed_args["out-dir"]

    YAXDefaults.workdir[] = outdir
    println(outdir)

    continent = parsed_args["continent"]
    tilefolder = parsed_args["tile"]
    folders = ["V01R01", "V0M2R4", "V1M0R1", "V1M1R1", "V1M1R2"]

    filenamelist = [glob("$(sub)/*$(continent)*20M/$(tilefolder)/*$(pol)_$(orbit)*.tif", indir) for sub in folders]
    allfilenames = collect(Iterators.flatten(filenamelist))

    relorbits = unique([split(basename(x), "_")[5][2:end] for x in allfilenames])
    y = parsed_args["year"]

    for relorbit in relorbits
        filenames = allfilenames[findall(contains("$(relorbit)_E"), allfilenames)]

        cube = gdalcube(filenames)
        path = joinpath(outdir, "$(tilefolder)_rqatrend_$(pol)_$(relorbit)_thresh_$(thresh)_year_$(y)")
        ispath(path * ".done") && continue
        tcube = cube[Time=Date(y - 1, 7, 1) .. Date(y + 1, 7, 1)]

        rqatrend(tcube; thresh, outpath=path * ".zarr", overwrite=true)
    end
end

main()