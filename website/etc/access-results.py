# accesss results
# requires zarrv2

import xarray as xr
import s3fs
import matplotlib.pyplot as plt

job_id = "test1"
ds_path = "E051N018T3_rqatrend_VH_D022_thresh_3.0.zarr"

# using HTTP

ds = xr.open_zarr(f"http://s3.fairsendd.eodchosting.eu/userdata/{job_id}/{ds_path}")
ds.layer.plot()
plt.show()

# using S3

s3 = s3fs.S3FileSystem(
    anon=True,
    client_kwargs={"endpoint_url": "http://s3.fairsendd.eodchosting.eu"},
)
store = s3fs.S3Map(root=f"userdata/{job_id}/{ds_path}", s3=s3, check=False)
ds = xr.open_zarr(store, consolidated=True)
print(ds)

ds.layer.plot()
plt.show()


# using stac catalog

import stackstac
import pystac

catalog = pystac.Catalog.from_file(
    f"http://s3.fairsendd.eodchosting.eu/userdata/{job_id}/catalog.json"
)
items = list(catalog.get_items())
ds = stackstac.stack(items, epsg=4326, resolution=0.1)


# using existing catalog

from pystac_client import Client

catalog = Client.open("https://planetarycomputer.microsoft.com/api/stac/v1")

items = catalog.search(
    collections=["sentinel-2-l2a"],
    bbox=[0, 0, 10, 10],
    datetime="2021-01-01/2021-01-02",
).get_all_items()
ds = stackstac.stack(items, epsg=4326, resolution=0.1)
ds
