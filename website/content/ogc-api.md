# OGC API


> [!NOTE]
>
> This part is still in development

Access the [OGC API - Processes](https://ogcapi.ogc.org/processes) at
the entry point http://ogc.api.fairsendd.eodchosting.eu. Further
documentation is provided at the [Swagger OpenAPI
page](http://ogc.api.fairsendd.eodchosting.eu/openapi).

Get information about the process:

``` bash
curl -X 'GET' \
  'http://ogc.api.fairsendd.eodchosting.eu/processes/squared?f=json' \
  -H 'accept: application/json'
```

      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed

      0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
    100  2522  100  2522    0     0  46703      0 --:--:-- --:--:-- --:--:-- 46703
    {
        "version":"0.1.0",
        "id":"squared",
        "title":"Squared processor",
        "description":"An example process that takes a number or integer and returns the squared result",
        "jobControlOptions":[
            "sync-execute"
        ],
        "keywords":[
            "squared"
        ],
        "links":[
            {
                "type":"text/html",
                "rel":"about",
                "title":"information",
                "href":"https://example.org/process",
                "hreflang":"en-US"
            },
            {
                "type":"application/json",
                "rel":"self",
                "href":"/processes/squared?f=json",
                "title":"Process description as JSON",
                "hreflang":"en-US"
            },
            {
                "type":"text/html",
                "rel":"alternate",
                "href":"/processes/squared?f=html",
                "title":"Process description as HTML",
                "hreflang":"en-US"
            },
            {
                "type":"text/html",
                "rel":"http://www.opengis.net/def/rel/ogc/1.0/job-list",
                "href":"/jobs?f=html",
                "title":"Jobs list as HTML",
                "hreflang":"en-US"
            },
            {
                "type":"application/json",
                "rel":"http://www.opengis.net/def/rel/ogc/1.0/job-list",
                "href":"/jobs?f=json",
                "title":"Jobs list as JSON",
                "hreflang":"en-US"
            },
            {
                "type":"application/json",
                "rel":"http://www.opengis.net/def/rel/ogc/1.0/execute",
                "href":"/processes/squared/execution?f=json",
                "title":"Execution for this process as JSON",
                "hreflang":"en-US"
            }
        ],
        "inputs":{
            "value":{
                "title":"Number",
                "description":"number or integer",
                "schema":{
                    "oneOf":[
                        "number",
                        "integer"
                    ]
                },
                "minOccurs":1,
                "maxOccurs":1,
                "metadata":null,
                "keywords":[
                    "number"
                ]
            }
        },
        "outputs":{
            "squared":{
                "title":"Squared",
                "description":"An example process that takes a number or integer and returns the squared result",
                "schema":{
                    "type":"object",
                    "contentMediaType":"application/json"
                }
            }
        },
        "example":{
            "inputs":{
                "value":3
            }
        },
        "outputTransmission":[
            "value"
        ]
    }

Execute the workflow:

``` bash
curl -X 'POST' \
  'http://ogc.api.fairsendd.eodchosting.eu/processes/squared/execution' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "inputs": {
    "value": 3
  }
}'
```

      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed

      0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
    100    73  100    37  100    36    569    553 --:--:-- --:--:-- --:--:--  1123
    {
        "id":"squared",
        "value":9
    }
