SOURCES = \
	reader_helper.mli reader_helper.ml \
	reader_def.mli  \
	protocol_def.mli  \
	extend_main.mli extend_main.ml

LIB_PACK_NAME = merlin_extend
RESULT = merlin_extend

PACKS = compiler-libs

all: pack-native-code

-include OCamlMakefile
