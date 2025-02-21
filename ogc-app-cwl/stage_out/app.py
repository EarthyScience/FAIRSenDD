#! /usr/bin/env python3

import os
import pystac
import zarr
import xarray as xr
from shapely.geometry import mapping, box
from pyproj import CRS, Transformer
import datetime
import click


@click.command()
@click.option("--out-dir")
@click.option("--continent")
@click.option("--start-date", type=click.DateTime())
@click.option("--end-date", type=click.DateTime())
def main(out_dir, continent, start_date, end_date):
    os.chdir(out_dir)

    # see https://github.com/TUW-GEO/Equi7Grid
    epsg_codes = {"EU": "EPSG:27704"}  # Europe

    crs_from = CRS.from_string(epsg_codes[continent])
    crs_to = CRS.from_epsg(4326)
    transformer = Transformer.from_crs(crs_from, crs_to)

    catalog = pystac.Catalog(
        id="results",
        description="FAIRSenDD results",
    )

    item_asset_path = "E051N018T3_rqatrend_VH_022_thresh_3.0_year_2021.zarr"

    zarr.consolidate_metadata(item_asset_path)
    ds = xr.open_dataset(item_asset_path, engine="zarr")

    bbox = transformer.transform(
        float(ds.X.min()), float(ds.Y.min())
    ) + transformer.transform(float(ds.X.max()), float(ds.Y.max()))
    geometry = mapping(box(*bbox))
    start_datetime = datetime.datetime.combine(start_date, datetime.datetime.min.time())
    end_datetime = datetime.datetime.combine(end_date, datetime.datetime.min.time())
    properties = ds.attrs

    item = pystac.Item(
        id=item_asset_path,
        geometry=geometry,
        bbox=bbox,
        datetime=None,
        start_datetime=start_datetime,
        end_datetime=end_datetime,
        properties=properties,
        stac_extensions=[
            "https://stac-extensions.github.io/xarray-assets/v1.0.0/schema.json",
            "https://stac-extensions.github.io/projection/v2.0.0/schema.json",
        ],
    )
    item.add_asset(
        key="data",
        asset=pystac.Asset(
            href=item_asset_path,
            media_type=pystac.MediaType.ZARR,
            roles=["data"],
            extra_fields={
                "xarray:open_kwargs": {
                    "consolidated": True,
                },
                "proj:code": epsg_codes[continent],
            },
        ),
    )
    catalog.add_item(item)

    catalog.normalize_and_save(
        root_href=out_dir, catalog_type=pystac.CatalogType.SELF_CONTAINED
    )


if __name__ == "__main__":
    main()
