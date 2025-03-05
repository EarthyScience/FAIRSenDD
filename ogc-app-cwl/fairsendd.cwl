#!/usr/bin/env cwl-runner

$graph:
- class: Workflow
  label: main
  doc: FAIRSenDD Recurrence Analysis for Sentinel-1 based Deforestation Detection

  requirements:
  - class: SubworkflowFeatureRequirement

  inputs:
    access-key:
      label: access-key
      doc: AWS access key
      type: string
    continent:
      label: continent
      doc: Continent ID within Equi7Grid. One of AF, AN, AS, EU, NA, OC, SA
      type: string
    end-date:
      label: end-date
      doc: End date of the time series to analyze in ISO 8601 format YYYY-MM-DD
      type: string
    in-dir:
      label: in-dir
      doc: Path to input directory containing Sentinel-1 Sigma0 tile data
      type: Directory
    out-dir:
      label: out-dir
      doc: Path to output directory
      type: string
    secret-key:
      label: secret-key
      doc: AWS secret key
      type: string
    start-date:
      label: start-date
      doc: Start date of the time series to analyze in ISO 8601 format YYYY-MM-DD
      type: string
    tiles:
      label: tiles
      doc: tile IDs of the area to be analyzed within Equi7Grid, e.g. E036N075T3
      type: string

  outputs:
    stac:
      doc: Path to output STAC catalog
      type: Directory
      outputSource: stage_out/stac

  steps:
    rqa:
      in:
        continent: continent
        end-date: end-date
        in-dir: in-dir
        start-date: start-date
        tiles: tiles
      run: '#cmd-rqa'
      out:
      - out_cube
    stage_out:
      id: stage_out
      in:
        access-key: access-key
        continent: continent
        data-dir: rqa/out_cube
        end-date: end-date
        out-dir: out-dir
        secret-key: secret-key
        start-date: start-date
      run: '#cmd-stage_out'
      out:
      - stac
  id: rqa
- class: CommandLineTool

  requirements:
    DockerRequirement:
      dockerPull: danlooo/fairsendd_rqa:latest

  inputs:
    continent:
      type: string
      inputBinding:
        prefix: --continent
        position: 1
    end-date:
      type: string
      inputBinding:
        prefix: --end-date
        position: 5
    in-dir:
      type: Directory
      inputBinding:
        prefix: --in-dir
        position: 2
    start-date:
      type: string
      inputBinding:
        prefix: --start-date
        position: 4
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
- class: CommandLineTool

  requirements:
    DockerRequirement:
      dockerPull: danlooo/fairsendd_stage_out:latest

  inputs:
    access-key:
      type: string
      inputBinding:
        prefix: --access-key
    continent:
      type: string
      inputBinding:
        prefix: --continent
        position: 2
    data-dir:
      type: Directory
      inputBinding:
        prefix: --data-dir
        position: 1
    end-date:
      type: string
      inputBinding:
        prefix: --end-date
        position: 4
    out-dir:
      type: string
      inputBinding:
        prefix: --out-dir
        position: 5
    secret-key:
      type: string
      inputBinding:
        prefix: --secret-key
    start-date:
      type: string
      inputBinding:
        prefix: --start-date
        position: 3

  outputs:
    stac:
      type: Directory
      outputBinding:
        glob: .
  id: cmd-stage_out
$namespaces:
  edam: http://edamontology.org/
  s: https://schema.org/
$schemas:
- https://schema.org/version/latest/schemaorg-current-https.rdf
- http://edamontology.org/EDAM_1.18.owl
cwlVersion: v1.0
s:author:
- hints:
  cwltool:Secrets:
    secrets:
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
- class: s:Person
  s:email: fairsendd@bgc-jena.mpg.de
  s:identifier: https://orcid.org/0000-0002-4024-4443
  s:name: Daniel Loos
s:citation: https://dx.doi.org/10.6084/m9.figshare.3115156.v2
s:codeRepository: https://github.com/EarthyScience/FAIRSenDD/
s:dateCreated: '2024-10-28'
s:license: https://spdx.org/licenses/Apache-2.0
