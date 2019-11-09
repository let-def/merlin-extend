An SDK to extend [merlin](https://github.com/ocaml/merlin) frontend

# Using a custom parser/reader for Merlin

This library allows to plug a custom parser to Merlin.
This is done by implementing the [Reader.V0](https://github.com/let-def/merlin-extend/blob/master/extend_protocol.ml) signature and generating a binary by instantiating the [Reader.Make](https://github.com/let-def/merlin-extend/blob/master/extend_main.ml) functor.

The main use is to support Reason syntax, see [ocamlmerlin_reason.cppo.ml](https://github.com/facebook/reason/blob/master/src/reason-merlin/ocamlmerlin_reason.cppo.ml).
