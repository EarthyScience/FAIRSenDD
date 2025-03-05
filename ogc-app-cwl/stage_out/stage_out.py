#! /usr/bin/env python3

import os
import pystac
import minio
import xarray as xr
from shapely.geometry import mapping, box
from pyproj import CRS, Transformer
import datetime
import click


def list_files(directory):
    file_list = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_list.append(os.path.relpath(os.path.join(root, file), directory))
    return file_list


@click.command()
@click.option(
    "--data-dir",
    required=True,
    type=click.Path(exists=True, dir_okay=True, file_okay=False),
)
@click.option(
    "--out-dir",
    required=True,
    type=click.Path(dir_okay=True, file_okay=False),
)
@click.option("--continent", type=str, required=True)
@click.option("--start-date", type=click.DateTime(formats=["%Y-%m-%d"]), required=True)
@click.option("--end-date", type=click.DateTime(formats=["%Y-%m-%d"]), required=True)
@click.option("--access-key", type=str, default=os.getenv("AWS_ACCESS_KEY_ID"))
@click.option("--secret-key", type=str, default=os.getenv("AWS_SECRET_ACCESS_KEY"))
@click.option("--endpoint", type=str, default="s3.fairsendd.eodchosting.eu")
@click.option("--secure-endpoint", type=bool, default=False, is_flag=True)
@click.option("--bucket-name", type=str, default="userdata")
def main(
    data_dir,
    out_dir,
    continent,
    start_date,
    end_date,
    access_key,
    secret_key,
    endpoint,
    secure_endpoint,
    bucket_name,
):
    client = minio.Minio(
        endpoint=endpoint,
        access_key=access_key,
        secret_key=secret_key,
        secure=secure_endpoint,
    )

    # see https://github.com/TUW-GEO/Equi7Grid
    epsg_codes = {
        "AF": "EPSG:27701",
        "AN": "EPSG:27702",
        "AS": "EPSG:27703",
        "EU": "EPSG:27704",
        "NA": "EPSG:27705",
        "OC": "EPSG:27706",
        "SA": "EPSG:27707",
    }

    # transform to WGS84 (STAC uses GeoJSON)
    # required by https://datatracker.ietf.org/doc/html/rfc7946#section-4
    crs_from = CRS.from_string(epsg_codes[continent])
    crs_to = CRS.from_epsg(4326)
    transformer = Transformer.from_crs(crs_from, crs_to)

    catalog = pystac.Catalog(
        id="results",
        description="FAIRSenDD results",
    )

    asset_paths = [
        d for d in os.listdir(data_dir) if os.path.isdir(os.path.join(data_dir, d))
    ]

    for rel_asset_path in asset_paths:
        abs_asset_path = os.path.join(data_dir, rel_asset_path)

        # load and check dataset
        ds = xr.open_dataset(abs_asset_path, engine="zarr")

        # upload dataset
        for file in list_files(abs_asset_path):
            object_name = os.path.join(out_dir, rel_asset_path, file)
            file_path = os.path.join(abs_asset_path, file)
            client.fput_object(bucket_name, object_name, file_path)

    bbox = transformer.transform(
        float(ds.X.min()), float(ds.Y.min())
    ) + transformer.transform(float(ds.X.max()), float(ds.Y.max()))
    geometry = mapping(box(*bbox))
    start_datetime = datetime.datetime.combine(start_date, datetime.datetime.min.time())
    end_datetime = datetime.datetime.combine(end_date, datetime.datetime.min.time())
    properties = ds.attrs

    item = pystac.Item(
        id=rel_asset_path,
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
        key="zarr-https",
        asset=pystac.Asset(
            href=rel_asset_path,
            media_type=pystac.MediaType.ZARR,
            roles=["zarr", "data", "https"],
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
        root_href=out_dir, catalog_type=pystac.CatalogType.RELATIVE_PUBLISHED
    )

    # upload catalog
    for file in list_files(out_dir):
        object_name = os.path.join(out_dir, file)
        file_path = os.path.join(out_dir, file)
        print(f"Uploading {file} to {object_name}")
        client.fput_object(bucket_name, object_name, file_path)


if __name__ == "__main__":
    main()
