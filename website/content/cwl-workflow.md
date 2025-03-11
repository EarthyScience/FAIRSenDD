# CWL Workflow


[Common Workflow Language (CWL)](https://www.commonwl.org/) is an open
standard for describing command line applications to combine them
together into workflows. The command line applications often packaged
into Docker container to handle dependencies and versions of the
corresponding binaries. CWL workflows are the keystone of [Earth
Observation Application Packages](https://docs.ogc.org/bp/20-089r1.html)
as standardized by OGC.

## Real world data set

This example is using Sentinel-1 Sigma Nought backscatter data as
processed using [Wagner et
al. 2021](https://www.mdpi.com/2072-4292/13/22/4622) in [Equi7Grid
projection](https://github.com/TUW-GEO/Equi7Grid). Similar world wide
data can be accessed via the [EODC STAC
catalog](https://services.eodc.eu/browser/#/v1/collections/SENTINEL1_SIG0_20M).
The following test dataset contains only a subset of a tile to make it
faster to process.

``` bash
git clone https://github.com/meggart/RQADeforestationTestData
cwltool https://raw.githubusercontent.com/EarthyScience/FAIRSenDD/refs/heads/main/ogc-app-cwl/fairsendd.cwl#cmd-rqa \
    --continent EU \
    --tiles E051N018T3 \
    --start-date 2021-01-01 \
    --end-date 2022-01-01 \
    --in-dir RQADeforestationTestData
```

    fatal: destination path 'RQADeforestationTestData' already exists and is not an empty directory.
    [1;30mINFO[0m /home/dloos/miniconda3/bin/cwltool 3.1.20240708091337
    [1;30mINFO[0m [job cmd-rqa] /tmp/lrhkgeaa$ docker \
        run \
        -i \
        --mount=type=bind,source=/tmp/lrhkgeaa,target=/olptDI \
        --mount=type=bind,source=/tmp/h3uda3t_,target=/tmp \
        --mount=type=bind,source=/home/dloos/prj/FAIRSenDD/website/content/RQADeforestationTestData,target=/var/lib/cwl/stg17b3e82c-7bc1-4ff5-bec4-afe8b761a3e7/RQADeforestationTestData,readonly \
        --workdir=/olptDI \
        --read-only=true \
        --user=2362:521 \
        --rm \
        --cidfile=/tmp/751qvyjq/20250311143159-678465.cid \
        --env=TMPDIR=/tmp \
        --env=HOME=/olptDI \
        danlooo/fairsendd_rqa:latest \
        --continent \
        EU \
        --in-dir \
        /var/lib/cwl/stg17b3e82c-7bc1-4ff5-bec4-afe8b761a3e7/RQADeforestationTestData \
        --tiles \
        E051N018T3 \
        --start-date \
        2021-01-01 \
        --end-date \
        2022-01-01
    [ Info: new driver key :zarr, updating backendlist.
    [ Info: new driver key :gdal, updating backendlist.
    [ Info: new driver key :netcdf, updating backendlist.
    [ Info: Write output to out.zarr
    relorbits = SubString{String}["022"]
    length(dates) = 184
      1.792063 seconds (8.75 M allocations: 444.176 MiB, 7.72% gc time, 98.43% compilation time)
    path = "out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0"
    size(cube) = (50, 74, 61)
    size(tcube) = (50, 74, 48)
    outpath = "out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr"
      4.110359 seconds (12.28 M allocations: 629.342 MiB, 19.92% gc time, 88.37% compilation time)
    [1;30mINFO[0m [job cmd-rqa] Max memory used: 810MiB
    [1;30mINFO[0m [job cmd-rqa] completed success
    {
        "out_cube": {
            "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr",
            "basename": "out.zarr",
            "class": "Directory",
            "listing": [
                {
                    "class": "File",
                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.done",
                    "basename": "E051N018T3_rqatrend_VH_D022_thresh_3.0.done",
                    "size": 0,
                    "checksum": "sha1$da39a3ee5e6b4b0d3255bfef95601890afd80709",
                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.done"
                },
                {
                    "class": "Directory",
                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr",
                    "basename": "E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr",
                    "listing": [
                        {
                            "class": "File",
                            "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/.zmetadata",
                            "basename": ".zmetadata",
                            "size": 2098,
                            "checksum": "sha1$1e5cab4fafc967967cd8b5f2ca1c085a73901bf1",
                            "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/.zmetadata"
                        },
                        {
                            "class": "Directory",
                            "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/layer",
                            "basename": "layer",
                            "listing": [
                                {
                                    "class": "File",
                                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/layer/0.0",
                                    "basename": "0.0",
                                    "size": 12653,
                                    "checksum": "sha1$f8af38fd7909464a25eeb7c4a15857deb6c3532b",
                                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/layer/0.0"
                                },
                                {
                                    "class": "File",
                                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/layer/.zattrs",
                                    "basename": ".zattrs",
                                    "size": 54,
                                    "checksum": "sha1$6308c95300c8fa2029526bd1dbaf14145d9acd8a",
                                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/layer/.zattrs"
                                },
                                {
                                    "class": "File",
                                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/layer/.zarray",
                                    "basename": ".zarray",
                                    "size": 190,
                                    "checksum": "sha1$f6ff9f2503dd57ddace6b59b168ca29f553292f8",
                                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/layer/.zarray"
                                }
                            ],
                            "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/layer"
                        },
                        {
                            "class": "Directory",
                            "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/X",
                            "basename": "X",
                            "listing": [
                                {
                                    "class": "File",
                                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/X/.zattrs",
                                    "basename": ".zattrs",
                                    "size": 45,
                                    "checksum": "sha1$2e7b4c4f612c94c0d3d006e2748a0f4258ad1806",
                                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/X/.zattrs"
                                },
                                {
                                    "class": "File",
                                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/X/.zarray",
                                    "basename": ".zarray",
                                    "size": 184,
                                    "checksum": "sha1$8112ff8d7d6d676db62674b3223953e586e22810",
                                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/X/.zarray"
                                },
                                {
                                    "class": "File",
                                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/X/0",
                                    "basename": "0",
                                    "size": 114,
                                    "checksum": "sha1$78d517402584b41e77edb234cb3fb629108860fd",
                                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/X/0"
                                }
                            ],
                            "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/X"
                        },
                        {
                            "class": "File",
                            "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/.zgroup",
                            "basename": ".zgroup",
                            "size": 17,
                            "checksum": "sha1$08e424c08f97fd3c7912e3d66a7e42ad818127b1",
                            "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/.zgroup"
                        },
                        {
                            "class": "File",
                            "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/.zattrs",
                            "basename": ".zattrs",
                            "size": 2,
                            "checksum": "sha1$bf21a9e8fbc5a3846fb05b4fa0859e0917b2202f",
                            "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/.zattrs"
                        },
                        {
                            "class": "Directory",
                            "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/Y",
                            "basename": "Y",
                            "listing": [
                                {
                                    "class": "File",
                                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/Y/.zattrs",
                                    "basename": ".zattrs",
                                    "size": 45,
                                    "checksum": "sha1$56f5964807358bcabd5a465171947d7623cc6dff",
                                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/Y/.zattrs"
                                },
                                {
                                    "class": "File",
                                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/Y/.zarray",
                                    "basename": ".zarray",
                                    "size": 184,
                                    "checksum": "sha1$73f1be4b6a5094366690999eeb27c5785d0fed2f",
                                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/Y/.zarray"
                                },
                                {
                                    "class": "File",
                                    "location": "file:///home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/Y/0",
                                    "basename": "0",
                                    "size": 157,
                                    "checksum": "sha1$2cddf4f912c2d70033ec1daa83b63bc6af0d14a1",
                                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/Y/0"
                                }
                            ],
                            "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/Y"
                        }
                    ],
                    "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr"
                }
            ],
            "path": "/home/dloos/prj/FAIRSenDD/website/content/out.zarr"
        }
    }[1;30mINFO[0m Final process status is success

List output files:

``` bash
find out.zarr -maxdepth 2
```

    out.zarr
    out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.done
    out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr
    out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/.zmetadata
    out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/layer
    out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/X
    out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/.zgroup
    out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/.zattrs
    out.zarr/E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr/Y

The directory `out.zarr` forms a [Zarr
Dataset](https://zarr.dev/datasets/) that can be opened as an n
dimensional array in various ways,
e.g. [xarray](https://docs.xarray.dev/en/stable/) in Pxthon and
[YAXArrays](https://juliadatacubes.github.io/YAXArrays.jl/stable/) in
Julia.
