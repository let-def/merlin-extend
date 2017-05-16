JBUILDER ?= jbuilder

all:
	$(JBUILDER) build

clean:
	rm -rf _build .merlin *.install

.PHONY: all clean
