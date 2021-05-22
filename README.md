# flower

Intention: merge all "nou", "xtref", "notches", and "tenjo" into single plugin.

  * pure python library backend to query and manipulate .nou data format.
  * TRY: syntax hi in .lua -- to make .nou format faster.
  * IDEA: embed and recognize .nou tasks into comments of any other source code.
  * CFG: use "Space" as global leader key for this "literal programming".

-----

# nou.vim

[![Build Status](https://travis-ci.org/amerlyq/nou.vim.svg?branch=master)](
    https://travis-ci.org/amerlyq/nou.vim)

Notes and outline united.

It's similar to *org-mode* but in no way compatible and there is no plans to make it so.
It was developed especially because my primary usecases look ugly in *org-mode* syntax too much (for my taste).


## Capabilities

  * extensive outline with contrasting visual distinctions between levels
  * plain notes in paragraphs
  * annotated decision making
  * web links hierarchy with titles
  * streamlined dataflows and callgraphs
  * inlined shell code examples
  * simple todo lists for weekly planning with priorities
  * cheat-sheets for programs
  * documentation
  * opinionated mind mapping

You can find non-exhaustive but acceptable list of possible syntax constructs inside of docs.

  * doc/nou-markup.txt
  * doc/nou-path.txt
  * doc/nou-keyvalue.txt


## Examples

You can see many examples of actually written and daily used docs in:

  * https://github.com/amerlyq/airy
  * https://github.com/amerlyq/aeternum

Of course you must have installed plugin first, otherwise without highlighting
you won't know, if it's individually nice to use or not.

TODO: add some direct links to ./doc dirs/files -- as examples of extensive usage of `*.nou`

## Add-ons

### Everywhere-notches

Enumeration of 100+ operator keywords highlighted everywhere over any other syntax file.
Useful to create personal action accents in programming comments, tasks, etc.

* https://github.com/amerlyq/aeternum/blob/master/documenting/fmt/notches.nou
* https://github.com/amerlyq/airy/blob/master/vim/plugin/everywhere-notches.vim

(I still haven't decided if it needs separate repo)

### Xtref

Timestamp-based cross-refs manipulation and tagging by braille-codes.
Allows you to tag and jump between your own knowledge database scattered over multiple repos.
Auto-annotate copied web-links to refer them from other places

* https://github.com/amerlyq/airy/blob/master/vim/plugin/xtref.vim
* https://github.com/amerlyq/airy/blob/master/qute/userscripts/yank_nou

(Planned to be merged with *tenjo* and published as separate multirepo)

### Tenjo

Distributed collaborative task-management specification and solution.

Actually `git` is much better than `taskwarrior` for this kind of staff.
Moreover it's often desirable to keep together tasks and temporary binary
artifacts (like books) alongside source code and documentation.
In that case `git-annex` or `git-lfs` help immeasurably.
We only need a way to manage and distribute tasks in git.

* https://github.com/amerlyq/tenjo

## Contribution

I really appreciate any snippet of documentation/code you can contribute,
-- if you find examples above personally appealing and useful.
After all I by myself can't compare with whole org-mode community :)

Alternatively you can propose some workflow -- useful for you personally.
And I will implement it, if it has a nice vibe to it.

Also you can look into `todo/*` long list of expected but still not implemented
features -- I hope some interesting ideas may inspire you.

## Inspired from

  * [vimoutliner](https://github.com/vimoutliner/vimoutliner)
  * [vim-notes](https://github.com/xolox/vim-notes)
  * [vimwiki](https://github.com/vimwiki/vimwiki)
