class: Workflow
cwlVersion: v1.0
id: kallisto_pe
label: kallisto-pe
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: fastqs
    type: 'File[]'
    'sbg:x': -227.7967529296875
    'sbg:y': 94.5
  - id: fasta-files
    type: 'File[]'
    'sbg:x': -300.7967529296875
    'sbg:y': -73.5
outputs:
  - id: quantification
    outputSource:
      - kallisto_quant/quantification
    type: File
    'sbg:x': 220.2032470703125
    'sbg:y': 83.5
steps:
  - id: kallisto_index
    in:
      - id: fasta-files
        source:
          - fasta-files
    out:
      - id: index
    run: ./kallisto-index.cwl
    'sbg:x': -163.796875
    'sbg:y': -68.5
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
    'sbg:x': 58.2032470703125
    'sbg:y': 76.5
requirements: []
