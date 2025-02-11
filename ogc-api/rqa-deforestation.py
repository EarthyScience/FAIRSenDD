import logging
import subprocess
from pygeoapi.process.base import BaseProcessor


from pycalrissian.context import CalrissianContext
from pycalrissian.job import CalrissianJob
from pycalrissian.execution import CalrissianExecution
import base64
import os
import yaml

LOGGER = logging.getLogger(__name__)

username = ""
password = ""

auth = base64.b64encode(f"{username}:{password}".encode("utf-8")).decode(
    "utf-8"
)

secret_config = {
    "auths": {
        "registry.gitlab.com": {
            "auth": ""
        },
        "https://index.docker.io/v1/": {
			"auth": ""
		},

    }
}

namespace_name = "default"

session = CalrissianContext(
            namespace=namespace_name,
            storage_class="standard",
            volume_size="10G",
            image_pull_secrets=secret_config,
            kubeconfig_file="/home/dloos/.kube/config", # Is this actually used?
)


session.initialise()




#: Process metadata and description
PROCESS_METADATA = {
    'version': '0.1.0',
    'id': 'rqa-deforestation',
    'title': {
        'en': 'RQADeforestation workflow of the FAIRSenDD project'
    },
    'description': {
        'en': 'Deforestation and forest change detection based on recurrence quantification analysis (RQA).'
    },
    'jobControlOptions': ['sync-execute', 'async-execute'],
    'keywords': ['forest', 'deforestation', "Sentinel-1"],
    'links': [{
        'type': 'text/html',
        'rel': 'paper',
        'title': 'research article about the underlying algorithm',
        'href': 'https://doi.org/10.1109/JSTARS.2020.3019333',
        'hreflang': 'en-US'
    },
    {
        'type': 'text/html',
        'rel': 'project',
        'title': 'website of the FAIRSenDD project',
        'href': 'http://fairsendd.eodchosting.eu/',
        'hreflang': 'en-US'
    },
    {
        'type': 'text/html',
        'rel': 'library',
        'title': 'software repository of the underlying Julia package',
        'href': 'https://github.com/EarthyScience/RQADeforestation.jl',
        'hreflang': 'en-US'
    },
    
    ],
    'inputs': {
        'continent': {
            'title': 'Continent ID',
            'description': 'Equi7Grid continent code for the tile to be processed',
            'schema': 'string',
            'minOccurs': 1,
            'maxOccurs': 1,
            'metadata': None
        },
         'tile': {
            'title': 'Tile ID',
            'description': 'Equi7Grid Tile code for the tile to be processed',
            'schema': 'string',
            'minOccurs': 1,
            'maxOccurs': 1,
            'metadata': None
        }       
    },
    'outputs': {
        'rqa-cube': {
            'title': 'RQA data cube of forest change',
            'description': 'Output data cube in Zarr format',
            'schema': {
                'type': 'object',
                'contentMediaType': 'application/json'
            }
        }
    },
    'example': {
        'inputs': {
            'continent': 'NA',
            'tile' : 'E036N075T3'
        }
    }
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

    def execute(self, data):        
        tile = data.get('tile')
        continent = data.get('continent')

        mimetype = 'application/json'

        continents = ["AF", "AN", "AS", "EU", "NA", "OC", "SA"]
        if continent not in continents:
            raise ProcessorExecuteError(f"continent must be one of {','.join(continents)}")


        # TODO: add cwl

        result = "s3://foo.bar"

        outputs = {
            'id': 'rqa-deforestation',
            'rqa-cube': result
        }

        return mimetype, outputs

    def __repr__(self):
        return f'<RQAProcessor> {self.name}'
