# OCR challenge for index cards

The goal of this task is to post-process the output from the Tesseract
OCR engine. Alternatively, it could be treated as an OCR, as images
are also available.

The data set is based on the index cards from [Korpus Frazeologiczny
Języka Polskiego](http://leksykografia.amu.edu.pl/).

## Metrics

The task will be evaluated using the following metrics:

 * CharMatch (main metric) — it measures the deviation between the
   output, the input (as obtained from Tesseract OCR) and the input;
   see
   <https://re-research.pl/ltc-2017-iayko-jassem-gralinski-obrebski.pdf>,
   page 4 (CharMatch penalizes unwanted changes more than WER/CER).
 * WER (Word Error Rate) — the equivalent of CER for words (number of words inserted, substituted
   and deleted divided by the total number of words).
 * CER (Character Error Rate) — the [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)
   between real text and the OCR engine output, divided by the total number of chacracters,

## Evaluation

You can carry out evaluation using the [GEval](https://gitlab.com/filipg/geval),
when you generate `out.tsv` files (in the same format as `expected.tsv` files):

```
wget https://gonito.net/get/bin/geval
chmod u+x geval
./geval -t dev-0
```

## Directory structure

* `README.md` — this file
* `config.txt` — GEval configuration file
* `images/` — images to be processed, referenced in TSV files
* `in-header.tsv` — one-line TSV file with column names for input data
* `out-header.tsv` — one-line TSV file with column names for the output data
* `train/` — directory with hand-annotated gold-standard OCR train data
* `train/in.tsv` — input data for the train set
* `train/expected.tsv` — expected (reference) data for the dev set
* `dev-0/` — directory with hand-annotated gold-standard OCR test data
* `dev-0/in.tsv` — input data for the dev set
* `dev-0/expected.tsv` — expected (reference) data for the dev set
* `test-A/` — directory with hand-annotated gold-standard OCR test data
* `test-A/in.tsv` — input data for the test set
* `test-A/expected.tsv` — expected (reference) data for the test set (hidden)

Note that we mean TSV, *not* CSV files. In particular, double quotes
are not considered special characters here! In particular, set
`quoting` to `QUOTE_NONE` in the Python `csv` module:

```python

    import csv
    with open('file.tsv', 'r') as tsvfile:
        reader = csv.reader(tsvfile, delimiter='\t', quoting=csv.QUOTE_NONE)
        for item in reader:
            pass
```

### Downloading image files

Image files are kept using [git-annex](https://git-annex.branchable.com).
If you need them, install git-annex and run `./annex-get-all.sh`.

## Format of the test sets

The input file (`in.tsv`) consists of 4 TAB-separated columns:

* the name of the test image (MD5 digest of the binary content with `.png` extension); these
  files are in `images/` directory,
* the ISO-639-3 language code of the source document (always `pol`),
* the pixel depth of an image (always 400),
* the output from Tesseract OCR to be corrected.

(The 2nd and 3rd field is for compatibility with other OCR challenges,
it's always, respectively, `pol` and `400` in this challenge.)

Each entry in the `expected.tsv` contains the text recognized from the test image.

The carriage returns (CR) and backslashs are replaced with `\n` and
`\\` respectively, so you should decode them, using for example this
Python code

    def decode_text(t):
       return t.replace('\\n', '\n').replace('\\\\', '\\')

Each line in the `expected.tsv.xz` corresponds to the line in
`in.tsv.xz`.

All the files are UTF-8 encoded.

Note that `out.tsv` and `expected.tsv` files have the `.tsv` extension
only for consistency. Actually they are just plain text files.

### Submission format

Each entry in `expected.tsv` contains entire text file to be
recognized, compressed to one line. In order to achieve best possible
results, one should format submitted `out.tsv` in similar way, i.e.
don't forget to encode backslashes and carriage returns:

    def encode_text(t):
        return t.replace('\\', '\\\\').replace('\n', '\\n')
