class: Workflow
cwlVersion: v1.0
id: kallisto_pe
label: kallisto-pe
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: fasta-files
    type: 'File[]'
    'sbg:x': -510.60113525390625
    'sbg:y': -114
  - id: fastqs
    type: 'File[]'
    'sbg:x': -379.60113525390625
    'sbg:y': 126
outputs:
  - id: quantification
    outputSource:
      - kallisto_quant/quantification
    type: File
    'sbg:x': 92.39886474609375
    'sbg:y': 64
steps:
  - id: kallisto_index
    in:
      - id: fasta-files
        source:
          - fasta-files
    out:
      - id: index
    run: ./kallisto-index.cwl
    'sbg:x': -354.6015625
    'sbg:y': -105
  - id: kallisto_quant
    in:
      - id: fastqs
        source:
          - fastqs
      - id: index
        source: kallisto_index/index
    out:
      - id: quantification
    run: ./kallisto-quant.cwl
    'sbg:x': -122.60113525390625
    'sbg:y': 85
requirements: []
