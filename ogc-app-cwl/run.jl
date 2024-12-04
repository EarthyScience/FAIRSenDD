#! /usr/bin/env 

using YAXArrays: YAXDefaults
using Glob:glob
#using ArgParse: @add_arg_table!
using RQADeforestation: gdalcube, rqatrend
using DimensionalData: (..)
using Dates: Date
using Distributed: addprocs, @everywhere
Threads.nthreads()
YAXDefaults.workdir[] = "/mnt/felix1/worldmap/data"
exeflags = `--threads=10 --heap-size-hint=8G`
#addprocs(4;exeflags)
#@everywhere using YAXArrays, RQADeforestation


#=
function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--thresh"
            help = "Threshold for the recurrence matrix computation"
            default = 3.
        "--pol", "-p"
            help = "Polarisation that should be stacked"
            default = "VH"
        "--year", "-y"
            help = "Year in which the RQA Trend should be detected. 
            We take a buffer of six month before and after the year to end up with two years of data."
            default = 2018
            arg_type = Int      
        "tile"
            help = "Tile that should be processed"
            required = true
        "orbit"
            help= "Orbit number or 'A' 'D' for ascending and descending"
            required=true
    end

    return parse_args(s)
end
=#

function main()
    pol = "VH"
    orbit = "*"
    thresh=3.0
    indir = "/eodc/products/eodc.eu/S1_CSAR_IWGRDH/SIG0/"
    tilefolder = "E048N018T3"
    continent = "EU"
    folders = ["V01R01","V0M2R4", "V1M0R1", "V1M1R1", "V1M1R2"]
    filenamelist = [glob("$(sub)/*$(continent)*20M/$(tilefolder)/*$(pol)_$(orbit)*.tif", indir) for sub in folders]

    allfilenames = collect(Iterators.flatten(filenamelist))


    relorbits = unique([split(basename(x), "_")[5][2:end] for x in allfilenames])
    for y in [2018,2019,2020,2021,2022, 2023]

    for relorbit in relorbits
        filenames = allfilenames[findall(contains("$(relorbit)_E"), allfilenames)]
        @time cube = gdalcube(filenames)
            path = joinpath(YAXDefaults.workdir[], "$(tilefolder)_rqatrend_$(pol)_$(relorbit)_thresh_$(thresh)_year_$(y)")
            @show path
            ispath(path*".done") && continue
            tcube = cube[Time=Date(y-1, 7,1)..Date(y+1,7,1)]

            @time rqatrend(tcube; thresh, outpath=path * ".zarr", overwrite=true)
            touch(path * ".done")
        end
    end
end

main()