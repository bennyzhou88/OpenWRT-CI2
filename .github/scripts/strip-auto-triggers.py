#!/usr/bin/env python3
"""去掉 .github/workflows 里所有自动触发（schedule、workflow_run），只保留手动触发。
fork 仓库里有定时任务会被 GitHub 整体禁用，所以每次同步上游后都要再跑一遍。
私有脚本，上游没有这个文件。"""
import glob
import re
import sys

AUTO = re.compile(r"^  (schedule|workflow_run):\s*$")
changed = []

for path in sorted(glob.glob(".github/workflows/*.yml")):
    lines = open(path, encoding="utf-8").read().split("\n")
    out, i = [], 0
    while i < len(lines):
        if AUTO.match(lines[i]):
            #连同紧挨着的 "  #注释" 行一起删掉
            while out and re.match(r"^  #", out[-1]):
                out.pop()
            i += 1
            #删掉缩进更深的子项
            while i < len(lines) and re.match(r"^    ", lines[i]):
                i += 1
            continue
        out.append(lines[i])
        i += 1
    if out != lines:
        open(path, "w", encoding="utf-8").write("\n".join(out))
        changed.append(path)

for p in changed:
    print("已去掉自动触发:", p)
if not changed:
    print("没有需要处理的自动触发")
sys.exit(0)
