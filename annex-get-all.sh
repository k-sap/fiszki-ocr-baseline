#!/bin/bash

git annex init

for file in images/*.png
do
    url=https://re-research.pl/git-annex-storage/fiszki-ocr/$file
    echo $url $file
done | git annex addurl --batch --with-files

git annex get images/*.png
