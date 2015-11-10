#!/usr/bin/env cwl-runner

class: CommandLineTool

description: |
  Usage: sort [OPTION]... [FILE]...
    or:  sort [OPTION]... --files0-from=F
  Write sorted concatenation of all FILE(s) to standard output.

dct:creator:
  "@id": "http://orcid.org/orcid.org/0000-0002-6130-1021"
  foaf:name: Denis Yuen
  foaf:mbox: "mailto:help@cancercollaboratory.org"


requirements:
  - class: ExpressionEngineRequirement
    id: "#node-engine"
    requirements:
    - class: DockerRequirement
      dockerPull: commonworkflowlanguage/nodejs-engine
    engineCommand: cwlNodeEngine.js
  - class: EnvVarRequirement
    envDef:
    - envName: "PATH"
      envValue: "/usr/local/bin/:/usr/bin:/bin"
  - class: DockerRequirement
    dockerPull: quay.io/collaboratory/dockstore-tool-linux-sort

inputs:
  - id: "#input"
    type: File
    inputBinding:
      position: 4

  - id: "#key"
    type: 
      type: array
      items: string 
    description: |
      -k, --key=POS1[,POS2]
      start a key at POS1, end it at POS2 (origin 1)

outputs:
  - id: "#sorted"
    type: File
    description: "The sorted file"
    outputBinding:
      glob:
        engine: "#node-engine" 
        script: $job['input'].path.split('/').slice(-1)[0] + '.sorted'

stdout: 
  engine: "#node-engine" 
  script: $job['input'].path.split('/').slice(-1)[0] + '.sorted'

baseCommand: ["sort"]

arguments:
  - valueFrom:
      engine: "#node-engine"
      script: $job['key'].map(function(i) {return "-k"+i;})
