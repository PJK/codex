CodEx CLI (CCLI) is a remote CLI interface to CodEx (http://codex2.ms.mff.cuni.cz/project/). It aims to speed you up by eliminating (bothersome) interaction with CodEx's web interface.

## Installation

Repo: `gitolite@pavelkalvoda.com:codex.git`

`git clone git://github.com/PJK/codex.git && cd codex`

`bundle`

`rake build`

`gem install pkg/codex-X.Y.Z.gem`

## Short tutorial

Basic invocation: `codex submit -l LOCATION -u USERNAME -g GROUPID -t TASKID FILENAME` will prompt you for your password, submit your solution and print result.
Example: 

```
$>codex submit -l codex.ms.mff.cuni.cz/codex -u pepa -g 56 -t 34 hello.c
Enter your password: *****RET
OK, waiting for results
Jailing user 'codex' (UID 1003, GID 1003) into directory '/home/codex/workers/eval2/jail'
Initializing... OK
Preparing sandbox... running locally (INSECURE), OK
Finding source... ./inbox/source.c
Compiling... OK
Test 1... <init> <run> <filter> <check> OK:OK (50 points)
Test 2... <init> <run> <filter> <check> OK:OK (50 points)
Test 3... <init> <run> <filter> <check> OK:OK (50 points)
Test 4... <init> <run> <filter> <check> OK:OK (50 points)
Test 5... <init> <run> <filter> <check> OK:OK (100 points)
Test 6... <init> <run> <filter> <check> OK:OK (100 points)
Test 7... <init> <run> <filter> <check> OK:OK (300 points)
Test 8... <init> <run> <filter> <check> OK:OK (300 points)
``` 

Riiight, but this doesn't save us any work, in fact, quite the contrary. That's where CCLI dotfile come in. They are essentially configuration YAML files containing default settings to use. CCLI will look for its dotfiles (`.codex`) in your current working directory and all its parent directories. "Closer", more specific dotfiles have priority (can override general settings from upper directories). Also, invocation flags take priority over all dotfile-specified settings.

| .codex name | flag name | example | remarks |
|:---|:---|:---|:---|
|`username`|`-u`, `--username`| `pepek` ||
|`password`| `-p`, `--password` | `l33tpswd`| You probably don't want your password hanging in your shell's history... |
|`location`| `-l`, `--location` | `https://codex.ms.mff.cuni.cz/codex` ||
|`group`| `-g`, `--group` | `42` | Can be determined from links in your groups overview scren (`https://codex.ms.mff.cuni.cz/codex/?module=groups`, `https://codex.ms.mff.cuni.cz/codex/?groupId=390&module=groups%2Ftasks`)|
|`task`|`-t`, `--task`| `4` ||
... or any CCLI global flag, using a full name! A developer, for example, might use `debug: true`.

Furthermore, you can use `codex init` to create your dotfiles for you.

"Okay, that's better. But I still have to figure out those IDs from the web..." you say. No, not really. `codex list` to the rescue! List groups, task & submissions:
```
$>codex list -g #at least login required                  
Programování 1 pro pokročilé (ZS)          390
Programování 2 pro pokročilé (LS)          427
...

```

```
$>codex list -t #at least group specification required
Hledání v setříděném poli (ze souboru)    5/5        2647
Byrokratický aparát                       5/5        2646
Théseus a Minotauros                     10/10       2645
...
```

```
$>codex list #task must be specified
8.5. (20h)                 cpp  0 %    163603                                         
8.5. (19:52)               cpp  0 %    163597                                         
12.10.2012 (14:35)         c    100 %  134191
```

Next up, look into a submission:

```
$>codex result
Jailing user 'codex' (UID 1003, GID 1003) into directory '/home/codex/workers/eval2/jail'
Initializing... OK
Preparing sandbox... running locally (INSECURE), OK
Finding source... ./inbox/source.cpp
Compiling... OK
Test 1... <init> <run> SG:Caught fatal signal 11 (SIGSEGV)
Test 2... <init> <run> SG:Caught fatal signal 11 (SIGSEGV)
Test 3... <init> <run> SG:Caught fatal signal 11 (SIGSEGV)
Test 4... <init> <run> SG:Caught fatal signal 11 (SIGSEGV)
Test 5... <init> <run> SG:Caught fatal signal 11 (SIGSEGV)
Test 6... <init> <run> SG:Caught fatal signal 11 (SIGSEGV)
Test 7... <init> <run> SG:Caught fatal signal 11 (SIGSEGV)
Test 8... <init> <run> SG:Caught fatal signal 11 (SIGSEGV)
```

... or even get the source code using `--fetch`

Finally, submitting your solutions:
```
$>codex submit source.c
``` 

##Development

CCLI is built using Mechanize, Nokogiri and Trollop. The source should be fairly easy to understand. If you want to improve/inspect CCLI, the `--debug` flag might be of interest to you -- it will enable extensive logging of program's operations. I also highly recommend using Pry for debugging and runtime inspection. It will be loaded if `CODEX_DEBUG` environment variable is specified.

CCLI uses Bundler, therefore you can easily track dependencies, manage revisions and redistribute modifies versions. Just see `rake -T`


##Some final notes

- Each subcommand also takes some options. They have to be specified *after* the subcommand. Exaple: `codex -g 15 --fetch solution` is wrong and won't work, should be `codex -g 15 solution --fetch` 
- CCLI won't work with Ruby 1.7 and older
- There is wealth of flags that modify behaviour of CCLI. Use `-h, --help` to your advantage
