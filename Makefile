all: pack-native-code pack-byte-code

SOURCES = \
	reader_helper.mli reader_helper.ml \
	reader_def.ml  \
	protocol_def.ml  \
	extend_main.mli extend_main.ml

RESULT = merlin_extend
LIB_PACK_NAME = merlin_extend
PACKS = compiler-libs

LIBINSTALL_FILES =  \
  extend_main.mli   \
  protocol_def.ml   \
  reader_def.ml     \
  reader_helper.mli \
  merlin_extend.cmi \
  merlin_extend.cmo \
  merlin_extend.cmx \
  merlin_extend.o

-include OCamlMakefile

install: libinstall

uninstall: libuninstall

reinstall:
	-$(MAKE) uninstall
	$(MAKE) install

OCAMLFLAGS += -g
OCAMLLDFLAGS += -g
