#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo
inputs:
  example_flag:
    type: boolean
    inputBinding:
      position: 1
      prefix: -f
  example_string:
    type: string
    inputBinding:
      position: 3
      prefix: --example-string
  example_int:
    type: int
    inputBinding:
      position: 2
      prefix: -i
      separate: false # -i9 のように、スペースを開けない。
  example_file:
    type: File? # 任意のinputであることを明示している。
    inputBinding:
      prefix: --file=
      separate: false
      position: 4

outputs: []