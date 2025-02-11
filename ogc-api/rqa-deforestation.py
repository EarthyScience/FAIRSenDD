import logging
import subprocess
from pygeoapi.process.base import BaseProcessor


from pycalrissian.context import CalrissianContext
from pycalrissian.job import CalrissianJob
from pycalrissian.execution import CalrissianExecution
import os
import yaml

LOGGER = logging.getLogger(__name__)

namespace_name = "default"
os.environ["CALRISSIAN_IMAGE"] = "docker.io/terradue/calrissian:0.12.0"

session = CalrissianContext(
    namespace=namespace_name,
    storage_class="standard",
    volume_size="10G",
    kubeconfig_file="~/.kube/config",
)

session.initialise()

#: Process metadata and description
PROCESS_METADATA = {
    "version": "0.1.0",
    "id": "rqa-deforestation",
    "title": {"en": "RQADeforestation workflow of the FAIRSenDD project"},
    "description": {
        "en": "Deforestation and forest change detection based on recurrence quantification analysis (RQA)."
    },
    "jobControlOptions": ["sync-execute", "async-execute"],
    "keywords": ["forest", "deforestation", "Sentinel-1"],
    "links": [
        {
            "type": "text/html",
            "rel": "paper",
            "title": "research article about the underlying algorithm",
            "href": "https://doi.org/10.1109/JSTARS.2020.3019333",
            "hreflang": "en-US",
        },
        {
            "type": "text/html",
            "rel": "project",
            "title": "website of the FAIRSenDD project",
            "href": "http://fairsendd.eodchosting.eu/",
            "hreflang": "en-US",
        },
        {
            "type": "text/html",
            "rel": "library",
            "title": "software repository of the underlying Julia package",
            "href": "https://github.com/EarthyScience/RQADeforestation.jl",
            "hreflang": "en-US",
        },
    ],
    "inputs": {
        "continent": {
            "title": "Continent ID",
            "description": "Equi7Grid continent code for the tile to be processed",
            "schema": "string",
            "minOccurs": 1,
            "maxOccurs": 1,
            "metadata": None,
        },
        "tiles": {
            "title": "Tile ID",
            "description": "Equi7Grid Tile code for the tile to be processed",
            "schema": "string",
            "minOccurs": 1,
            "maxOccurs": 1,
            "metadata": None,
        },
    },
    "outputs": {
        "rqa-cube": {
            "title": "RQA data cube of forest change",
            "description": "Output data cube in Zarr format",
            "schema": {"type": "object", "contentMediaType": "application/json"},
        }
    },
    "example": {"inputs": {"continent": "EU", "tiles": "E051N018T3"}},
}


class RQAProcessor(BaseProcessor):
    """RQAProcessor"""

    # client: docker.client.DockerClient

    def __init__(self, processor_def):
        """
        Initialize object

        :param processor_def: provider definition
        :returns: pygeoapi.process.rqa-deforestation.RQAProcessor
        """

        # self.client = docker.from_env()
        # println(self.client)
        super().__init__(processor_def, PROCESS_METADATA)

        with open("/app/fairsendd.cwl", "r") as stream:
            self.cwl = yaml.safe_load(stream)

    def execute(self, data, outputs):
        print(1213)

        tile = data.get("tile")
        continent = data.get("continent")

        continents = ["AF", "AN", "AS", "EU", "NA", "OC", "SA"]
        if continent not in continents:
            raise ProcessorExecuteError(
                f"continent must be one of {','.join(continents)}"
            )

        print(1)

        params = {
            "continent": continent,
            "tiles": tile,
            "years": "2021",  # TODO: make this a parameter
            "output": "s3://foo.bar",
        }

        job = CalrissianJob(
            cwl=self.cwl,
            params=params,
            runtime_context=session,
            cwl_entry_point="rqa",
            max_cores=10,
            max_ram="8G",
            tool_logs=True,
        )

        execution = CalrissianExecution(job=job, runtime_context=session)
        execution.submit()
        execution.monitor()

        # TODO: get the output from the execution
        outputs = {"id": "rqa-deforestation", "rqa-cube": 3}

        return "application/json", outputs

    def __repr__(self):
        return f"<RQAProcessor> {self.name}"
