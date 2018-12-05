# cwlでつまずいたところ

## Solved : 181201 kallisto workflowでindexがうまく引き渡されない

kallistoのワークフローの作成をrabix composerでやっているのですが、tool単体ではテストはうまく行ったのですが、新しいワークフローを作るとindexがうまくkallisto_quantに渡されません。なにか工夫がいるのでしょうか？tool自体は[https://github.com/common-workflow-language/workflows](https://github.com/common-workflow-language/workflows) から取ってきました。ワークフローはrabix composerで作りました。

使用したファイルはすべて[https://github.com/yyoshiaki/cwl_user_guide/tree/master/errors/kallisto_index](https://github.com/yyoshiaki/cwl_user_guide/tree/master/errors/kallisto_index) にまとめてあります。特におかしいワークフローは[kallisto-pe.cwl](https://github.com/yyoshiaki/cwl_user_guide/tree/master/errors/kallisto_index/kallisto-pe.cwl) です。

![scr](kallisto_index/img/181201.png)

```
[2018-12-01 01:11:51.378] [INFO] Trying to find cached results in the directory rabix-cache/root/.kallisto_quant.meta
[2018-12-01 01:11:51.378] [INFO] Cache directory doesn't exist. Directory rabix-cache/root/.kallisto_quant.meta
[2018-12-01 01:11:51.397] [DEBUG] Collecting outputs for root.kallisto_quant.
[2018-12-01 01:11:51.401] [INFO] Glob service didn't find any files.
[2018-12-01 01:11:51.427] [INFO] Job root.kallisto_quant failed with exit code 1. with message: 
Error: kallisto index file missing


[2018-12-01 01:11:51.429] [DEBUG] Job root.kallisto_quant, rootId: 658fa103-f0e3-46c7-8071-d72cbfe94f50 failed: Job root.kallisto_quant failed with exit code 1. with message: 
Error: kallisto index file missing


[2018-12-01 01:11:51.429] [DEBUG] handleUnusedFiles of 658fa103-f0e3-46c7-8071-d72cbfe94f50: []
[2018-12-01 01:11:51.429] [DEBUG] handleUnusedFilesIfAny(658fa103-f0e3-46c7-8071-d72cbfe94f50)
[2018-12-01 01:11:51.429] [DEBUG] onJobFailed(jobId=b2ce97da-22fd-3dc8-a2ce-0fb68ce361b4)
[2018-12-01 01:11:51.429] [INFO] Composer: {  "message" : "Job root.kallisto_quant failed with exit code 1. with message: \nError: kallisto index file missing\n\n",  "status" : "FAILED",  "stepId" : "root.kallisto_quant"}
[2018-12-01 01:11:51.432] [DEBUG] Root job 658fa103-f0e3-46c7-8071-d72cbfe94f50 failed. Job root.kallisto_quant failed with exit code 1. with message: 
Error: kallisto index file missing
```

### 解決策

Rabixの[issue](https://github.com/rabix/composer/issues/418#issuecomment-444257454)で解決策を教えてもらった。`kallisto-index.cwl`の`glob`がhardな指定だったのが原因だったよう。細かくはまだ理解が追いついていないが、とにかく動いた。

>You will note that there is no inputs.index_name
I changed it to *.idx since the index file name is hardcoded as index.idx
Looks like at some point someone wanted to be able to name the index file and coded stuff up accordingly and then changed to the hardcoded form but forgot to change the glob.

kallisto-index.cwl

```
glob: $(inputs.index_name)

-> 

glob: '*.idx'
```

![img](https://user-images.githubusercontent.com/19543497/49489669-8a5a8500-f88f-11e8-8dc6-7685bc35a2d8.png)