#!/usr/bin/env cwl-runner

$graph:
- class: Workflow
  label: rqa
  doc: FAIRSenDD Recurrence Analysis for Sentinel-1 based Deforestation Detection

  inputs:
    continent:
      label: continent
      doc: Continent ID within Equi7Grid. One of AF, AN, AS, EU, NA, OC, SA
      type: string
    in-dir:
      label: in-dir
      doc: Path to input directory containing Sentinel-1 Sigma0 tile data
      type: Directory
    tiles:
      label: tiles
      doc: tile IDs of the area to be analyzed within Equi7Grid, e.g. E036N075T3
      type: string

  outputs:
    out_cube:
      doc: Path to output zarr data cube
      type: Directory
      outputSource: rqa/out_cube

  steps:
    rqa:
      in:
        continent: continent
        in-dir: in-dir
        tiles: tiles
      run: '#cmd-rqa'
      out:
      - out_cube
  id: rqa
- class: CommandLineTool

  requirements:
    DockerRequirement:
      dockerPull: danlooo/rqa_deforestation:latest

  inputs:
    continent:
      type: string
      inputBinding:
        prefix: --continent
        position: 1
    in-dir:
      type: Directory
      inputBinding:
        prefix: --in-dir
        position: 2
    tiles:
      type: string
      inputBinding:
        prefix: --tiles
        position: 3

  outputs:
    out_cube:
      type: Directory
      outputBinding:
        glob: out.zarr
  id: cmd-rqa
$namespaces:
  edam: http://edamontology.org/
  s: https://schema.org/
$schemas:
- https://schema.org/version/latest/schemaorg-current-https.rdf
- http://edamontology.org/EDAM_1.18.owl
cwlVersion: v1.2
s:author:
- class: s:Person
  s:email: fairsendd@bgc-jena.mpg.de
  s:identifier: https://orcid.org/0000-0002-4024-4443
  s:name: Daniel Loos
s:citation: https://dx.doi.org/10.6084/m9.figshare.3115156.v2
s:codeRepository: https://github.com/EarthyScience/FAIRSenDD/
s:dateCreated: '2024-10-28'
s:license: https://spdx.org/licenses/Apache-2.0
