# ChangeloGen

- Conflict-less `changelog.md` generator with categories for Nim.

```console
$ changelogen
1       changelog/adds/example.md
2       changelog/adds/simple.md
3       changelog/removes/something.md


# v1.1.1 - 2020-03-23T15:54:48

## adds

* Honestly is just a simple addition.
  `Juan 2020-02-17t18:40:39+01:00` [8f73753a2](http://github.com/nim-lang/nim/compare/8f73753a2...devel)
* Add the ability to Divive by zero.
  `Juan 2020-02-17t18:40:39+01:00` [8f73753a2](http://github.com/nim-lang/nim/compare/8f73753a2...devel)


## removes

* Remove the Compiler itself, we detected most Bugs come from it, so we removed it.
  `Juan 2020-02-17t18:40:39+01:00` [8f73753a2](http://github.com/nim-lang/nim/compare/8f73753a2...devel)


## breaks

* No news in this Category.


## fixes

* No news in this Category.

$
$ changelogen --help
changelogen [options] path
  --version                  Version.
  --changelogVersion="2.0.0" Version to generate Changelog.md for (SemVer string)
  --reset                    Reset all folders and delete all MD files at exit.

$
```


# Use

- Changelog is a Folder instead of a File.
- Changelog Folder gets fill with tiny `*.md` files.
- When ready to release a new version, run `changelogen`.
- `changelogen` walks all `*.md` files and generates 1 `changelog.md` with extra info from Git.
- Optionally it can Reset all the folders and delete all old `*.md` files at exit.


# Defines

- `userRepo` string, GitHub User/Repo for your Changelog, eg `"nim-lang/Nim"`.
- `mainBranch` string, GitHub main Branch for your Changelog, eg `"devel"`.
- `filename`  string, output filename for your Changelog, eg `"changelog.md"`.
- `categories` string, comma separated values, categories for your Changelog,
  eg `"adds,removes,breaks,fixes"` or `"core,wip,backward_compatibility,bugs"`.
