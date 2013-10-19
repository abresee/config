#!/usr/bin/env python
from os import getcwd, listdir, chdir, path
from sys import argv
from shutil import move
from re import compile as regex

src_dir = argv[1]
go = None
if len(argv)> 2:
    go = bool(argv[2])
src_pattern = regex(r'The Simpsons - S(?P<season>\d{2})E(?P<episode>\d{2}) - (?P<title>[^\.]*)\.(?P<ext>\w+)')

dest_template = "{n} - {t}.{e}"
transform = {}

# grab info
season, ext = None, None
for filename in listdir(src_dir):
    m = src_pattern.match(filename)
    if m:
        transform[filename]     = m.group("episode","title","ext")
        if not season:
            season = m.group("season")
        else:
            assert season == m.group("season")
        if not ext:
            ext = m.group("ext")
        else:
            assert ext == m.group("ext")

renames = {src : dest_template.format(n=num, t=title, e=ext) for src, (num, title, ext) in transform.items()}
dest_dir = "S{s} {e}".format(s=season,e=ext)

print("to rename:")
for src, dest in sorted(renames.items()):
    print("{s}... --> {d}".format(s=src[:25], d=dest))
print("dir: {s} --> {d}".format(s=src_dir, d=dest_dir))


if go:
    chdir(src_dir)
    for src, dest in renames.items():
        move(src,dest)
    chdir("..")
    move(src_dir,dest_dir)

