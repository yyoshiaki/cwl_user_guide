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

- Inputs are described in the inputs section of a CWL description.
- Files should be described with class: File.
- You can use the inputBinding section to describe where and how an input appears in the command.
