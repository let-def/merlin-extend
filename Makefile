DUNE ?= dune

all:
	$(DUNE) build

clean:
	rm -rf _build .merlin *.install

.PHONY: all clean
