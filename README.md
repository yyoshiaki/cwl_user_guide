# cwl_user_guide
[Commom Workflow Language User Guide](https://www.commonwl.org/user_guide/)のノート。


## 1. Introduction

What is Common Workflow Language? 
Why might I want to learn to use CWL?

- CWL describes command line tools and workflows.
- CWL is not software.
- Descriptions in CWL aid portability between environments


## 2. First Example

cwl toolの作り方、インプットの入れ方。

- CWL documents are written in YAML and/or JSON.
- The command called is specified with baseCommand.
- Each expected input is described in the inputs section.
- Input values are specified in a separate YAML file.
- The tool description and input files are provided as arguments to a CWL runner.

```bash
$ cwl-runner 1st-tool.cwl echo-job.yml 
```


## 3. Essential Input Parameters

それぞれのinputは`id`と`type`を持っている。`type`にはいろいろある。`inputBinding`でinputのあり方を指定する。（任意）fileはyamlで`class: File`と指定する。

> Available primitive types are string, int, long, float, double, and null; complex types are array and record; in addition there are special types File, Directory and Any.

- Inputs are described in the `inputs` section of a CWL description.
- Files should be described with `class: File`.
- You can use the `inputBinding` section to describe where and how an input appears in the command.

```bash
$ cwl-runner inp.cwl inp-job.yml
```

```yaml
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
```

```yaml
example_flag: true
example_string: hello
example_int: 42
example_file:
  class: File
  path: whale.txt
```

## 4. Returning Output Files

Outputは`id`と`type`をもつ。globで"吐き出す"出力ファイル名を指定するが、詳しくわからないときはワイルドカードが使える。**ただしその場合、クォーテーションがいる。**

- Outputs are described in the `outputs` section of a CWL description.
- The field `outputBinding` describes how to to set the value of each output parameter.
- Wildcards are allowed in the `glob` field.

```bash
$ touch hello.txt && tar -cvf hello.tar hello.txt
$ cwl-runner tar.cwl tar-job.yml
```

```yaml
outputs:
  example_out:
    type: File
    outputBinding:
      glob: test.txt # glob: '*.txt'
```

## 5. Capturing Standard Output

ツールのstdoutをcaptureするにはどうするか。`stdout`というパラメーターでstdoutをファイルに書くが、その際`type: stdout`がちゃんとないといけない。

- Use the `stdout` field to specify a filename to capture streamed output.
- The corresponding output parameter must have type: `stdout`.

```bash
$ cwl-runner stdout.cwl echo-job.yml
```

```yaml
cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo
stdout: output.txt
inputs:
  message:
    type: string
    inputBinding:
      position: 1
outputs:
  example_out:
    type: stdout
```

rabixでみるとこんな感じ

![rabix](img/5-1.png)

## 6. Parameter References

`$(inputs.extractfile)`, `$(inputs["extractfile"])`, and `$(inputs['extractfile'])`は一緒。
ちなみにFile名とかを使うときはたとえば `$(inputs.tarfile.path)`。parameter referenceで使えるもの一覧は[ここ](https://www.commonwl.org/user_guide/06-params/index.html)。


- Some fields permit parameter references enclosed in $(...).
- References are written using a subset of Javascript syntax.

```bash
$ rm hello.tar || true && touch goodbye.txt && tar -cvf hello.tar goodbye.txt
$ cwl-runner tar-param.cwl tar-param-job.yml
```

## 7. Running Tools Inside Docker

docker containerの指定はhintsでかく。`CMD [ "node" ]`とかで終わっていなくてもENTRYPOINTを指定しなくてもコンテナの中にそのツールが入っていれば大丈夫そう。

```yaml
baseCommand: node
hints:
  DockerRequirement:
    dockerPull: node:slim
inputs:
  src:
    type: File
    inputBinding:
      position: 1
```

- Containers can help to simplify management of the software requirements of a tool.
- Specify a Docker image for a tool with DockerRequirement in the hints section.

```bash
$ echo "console.log(\"Hello World\");" > hello.js
$ cwl-runner docker.cwl docker-job.yml
```

## 8. Additional Arguments and Parameters

argumentsでパラメーターを指定しよう。ちなみに、`runtime` namespaceを使っている。他には`$(runtime.outdir)`,`$(runtime.tmpdir)`, `$(runtime.ram)`, `$(runtime.cores)`, ``$(runtime.outdirSize)`, `$(runtime.tmpdirSize)`などがある。

```yaml
arguments: ["-d", $(runtime.outdir)]
```


- Use the arguments section to describe command line options that do not correspond exactly to input parameters.
- Runtime parameters provide information about the environment when the tool is actually executed.
- Runtime parameters are referred under the runtime namespace.

```bash
$ echo "public class Hello {}" > Hello.java
$ cwl-runner arguments.cwl arguments-job.yml
```

## 9. Array Inputs

- Array parameter definitions are nested under the type field with type: array.
- The appearance of array parameters on the command line differs depending on with the inputBinding field is provided in the description.
- Use the itemSeparator field to control concatenatation of array parameters.

```yaml
inputs:
  filesA:
    type: string[]
    inputBinding:
      prefix: -A
      position: 1

  filesB:
    type:
      type: array
      items: string
      inputBinding:
        prefix: -B=
        separate: false
    inputBinding:
      position: 2

  filesC:
    type: string[]
    inputBinding:
      prefix: -C=
      itemSeparator: ","
      separate: false
      position: 4
```

```yaml
filesA: [one, two, three]
filesB: [four, five, six]
filesC: [seven, eight, nine]
```

```bash
$ cwl-runner array-inputs.cwl array-inputs-job.yml
...
[job array-inputs.cwl] /private/tmp/docker_tmpe6z2k_w3$ echo \
    -A \
    one \
    two \
    three \
    -B=four \
    -B=five \
    -B=six \
    -C=seven,eight,nine > /private/tmp/docker_tmpe6z2k_w3/output.txt
```

### 補足　inputがFileのarrayのとき

```
fastq:
- {class: File, path: sample1_R1_001.fastq.gz}
- {class: File, path: sample2_R1_001.fastq.gz}
```

## 10. Array Outputs

outputが複数ファイルのときなどはoutputにarrayを。ワイルドカードが便利。

- You can capture multiple output files into an array of files using glob.
- Use wildcards and filenames to specify the output files that will be returned after tool execution.

```yaml
baseCommand: touch
inputs:
  touchfiles:
    type:
      type: array
      items: string
    inputBinding:
      position: 1
outputs:
  output:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.txt"
```

