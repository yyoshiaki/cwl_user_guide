class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
baseCommand:
  - kallisto
  - index
inputs:
  - format: 'http://edamontology.org/format_1929'
    id: fasta-files
    type: 'File[]'
    inputBinding:
      position: 0
outputs:
  - id: index
    type: File
    outputBinding:
      glob: '*.idx'
arguments:
  - '--index'
  - index.idx
hints:
  - class: DockerRequirement
    dockerPull: insilicodb/kallisto
