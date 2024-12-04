#!/usr/bin/env cwl-runner

$graph:
- class: Workflow
  label: add numbers
  doc: Example workflow adding two numbers in Julia

  inputs:
    a:
      label: a
      doc: The first summand
      type: double
    b:
      label: b
      doc: The second summand
      type: double

  outputs:
    c:
      doc: the sum of the two numbers
      type: double
      outputSource: add/c

  steps:
    add:
      in:
        a: a
        b: b
      run: '#cmd-add'
      out:
      - c
  id: add-numbers
- class: CommandLineTool

  requirements:
    DockerRequirement:
      dockerPull: danlooo/cwl-example:latest
    InlineJavascriptRequirement: {}

  inputs:
    a:
      type: double
      inputBinding:
        position: 1
    b:
      type: double
      inputBinding:
        position: 2

  outputs:
    c:
      type: double
      outputBinding:
        glob: stdout.txt
        outputEval: $(parseFloat(self[0].contents))
        loadContents: true
  stdout: stdout.txt
  id: cmd-add
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
