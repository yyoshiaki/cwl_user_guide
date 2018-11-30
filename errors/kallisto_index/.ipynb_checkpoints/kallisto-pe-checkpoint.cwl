class: Workflow
cwlVersion: v1.0
id: kallisto_pe
label: kallisto-pe
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: fastqs
    type: 'File[]'
    'sbg:x': -205.7967529296875
    'sbg:y': 139.5
  - id: fasta-files
    type: 'File[]'
    'sbg:x': -352
    'sbg:y': -26
outputs:
  - id: quantification
    outputSource:
      - kallisto_quant/quantification
    type: File
    'sbg:x': 107
    'sbg:y': 96
steps:
  - id: kallisto_index
    in:
      - id: fasta-files
        source:
          - fasta-files
    out:
      - id: index
    run: ./kallisto-index.cwl
    'sbg:x': -181
    'sbg:y': -25
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
    'sbg:x': -16.7967529296875
    'sbg:y': 91.5
requirements: []
