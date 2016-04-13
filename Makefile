all: native-code-library byte-code-library

SOURCES = \
	extend_protocol.ml  \
	extend_helper.mli extend_helper.ml \
	extend_main.mli extend_main.ml

RESULT = merlin_extend
PACKS = compiler-libs

LIBINSTALL_FILES =  \
	extend_protocol.ml  \
	extend_protocol.cmi \
	extend_helper.mli \
	extend_helper.cmi \
	extend_main.mli \
	extend_main.cmi \
  merlin_extend.cma \
  merlin_extend.cmxa \
  merlin_extend.a

-include OCamlMakefile

install: libinstall

uninstall: libuninstall

reinstall:
	-$(MAKE) uninstall
	$(MAKE) install

OCAMLFLAGS += -g
OCAMLLDFLAGS += -g
