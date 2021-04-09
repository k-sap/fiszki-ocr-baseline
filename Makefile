
all: dev-0/out.tsv test-A/out.tsv

%/out.tsv: %/in.tsv
	cut -f 4 < $< > $@
