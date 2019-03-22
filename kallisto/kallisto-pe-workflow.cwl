class: Workflow
cwlVersion: v1.0
id: kallisto_pe_workflow
label: kallisto-pe-workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com'
inputs:
  - id: fastqs
    type: 'File[]'
    'sbg:x': -191.7967529296875
    'sbg:y': 80.5
  - id: fasta-files
    type: 'File[]'
    'sbg:x': -349.0525817871094
    'sbg:y': -77.5
outputs:
  - id: quantification
    outputSource:
      - kallisto_quant/quantification
    type: File
    'sbg:x': 222.94740295410156
    'sbg:y': 77.5
steps:
  - id: kallisto_index
    in:
      - id: fasta-files
        source:
          - fasta-files
    out:
      - id: index
    run: ./kallisto-index.cwl
    'sbg:x': -166.796875
    'sbg:y': -75.5
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
    'sbg:x': 52.2032470703125
    'sbg:y': 61.5
requirements: []
