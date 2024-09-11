using Pkg
Pkg.add(url="https://github.com/Open-EO/openeo-julia-client.git")

using OpenEOClient
con = connect("openeo.dataspace.copernicus.eu/openeo", "", OpenEOClient.oidc_auth)
s1 = con.load_collection(
    "SENTINEL1_GRD",
    BoundingBox(west=11.293602, south=46.460163, east=11.382866, north=46.514768),
    ["2021-01-01", "2021-01-08"];
    bands=["VV", "VH"],
    properties=Dict("sat:orbit_state" => ProcessCall("eq", Dict(:x => Dict(:from_parameter => :value), :y => :ASCENDING)) |> ProcessGraph)
)
s2 = con.sar_backscatter(s1; coefficient="sigma0-ellipsoid", elevation_model="COPERNICUS_30")
s3 = con.save_result(s2, "GTiff")
con.compute_result(s3)