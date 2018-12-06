class: Workflow
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: reads
    type: 'File[]'
    'sbg:x': -3
    'sbg:y': 176
  - id: transcripts
    type: 'File[]'
    'sbg:x': 0
    'sbg:y': 0
outputs:
  - id: quants
    outputSource:
      - quantifying/quantification
    type: File
    'sbg:x': 514.5264892578125
    'sbg:y': 53.5
steps:
  - id: indexing
    in:
      - id: fasta-files
        source:
          - transcripts
    out:
      - id: index
    run: ./kallisto-index.cwl
    'sbg:x': 143.953125
    'sbg:y': 3.5
  - id: quantifying
    in:
      - id: fastqs
        source:
          - reads
      - id: index
        source: indexing/index
    out:
      - id: quantification
    run: ./kallisto-quant.cwl
    'sbg:x': 309.984375
    'sbg:y': 46.5
hints:
  - dockerPull: insilicodb/kallisto
    undefined: DockerRequirement
requirements: []
