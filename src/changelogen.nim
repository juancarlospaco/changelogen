import os, json, strutils, times, osproc, parseopt

const
  categories {.strdefine.} = (
    "adds_stdlib,removes_stdlib,breaks_stdlib,fixes_stdlib," &
    "adds_compiler,removes_compiler,breaks_compiler,fixes_compiler," &
    "adds_tools,removes_tools,breaks_tools,fixes_tools").split","
  userRepo {.strdefine.} = "nim-lang/Nim"
  mainBranch {.strdefine.} = "devel"
  filename {.strdefine.} = "changelog.md"
  cmd = "git log -1 --pretty='format:`%aN %cI` [%h](http://github.com/" & userRepo & "/compare/%h..." & mainBranch & ")' "

template genDirs(path: string) =
  discard existsOrCreateDir(path)
  for folder in categories: discard existsOrCreateDir(path / folder)

template resetDirs(path: string) =
  removeDir(path)
  genDirs(path)

proc md2json(path: string): JsonNode =
  result = parseJson"{}"
  for category in categories:
    var temp = ""
    for md in walkPattern(path / category / "*.md"):
      when not defined(release): echo md
      var str = readFile(md).strip
      if str[0] != '*': str = "* " & str
      temp.add indent(str, 2).strip
      let x = execCmdEx(cmd & md)
      if x.exitCode == 0: temp.add "\n  " & x.output.normalize.strip & "\n"
    result[category] = %temp

proc render(changelog: JsonNode, ver: string): string =
  result = "# v" & ver & " - " & $now() & "\n\n"
  for c in changelog.pairs:
    result.add("\n\n## " & c.key & "\n\n" &
      (if c.val.getStr.len == 0: "* No news." else: c.val.getStr) & "\n")
  writeFile(filename, result)

proc main(path, ver: string, reset: bool) =
  genDirs(path)
  echo render(md2json(path), ver)
  if reset: resetDirs(path)

when isMainModule:
  const helpMsg = """changelogen [options] path
  --version                  Version.
  --changelogVersion="2.0.0" Version to generate Changelog.md for (SemVer string)
  --reset                    Reset all folders and delete all MD files at exit. """
  var
    reset: bool
    ver = NimVersion
    path = "changelog"
  for keyKind, key, value in getopt():
    case keyKind
    of cmdShortOption, cmdLongOption:
      case key.normalize
      of "version": quit(NimVersion, 0)
      of "help", "h": quit(helpMsg, 0)
      of "changelogversion": ver = value
      of "reset": reset = true
    of cmdArgument: path = key
    of cmdEnd: quit("Wrong arguments, see: --help", 1)
  main(path = path, ver = ver, reset = reset)
