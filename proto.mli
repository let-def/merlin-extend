(** Description of a buffer managed by Merlin *)
type buffer = {
  (** Path of the buffer in the editor.
      The path is absolute if it is backed by a file, although it might not yet
      have been saved in the editor.
      The path is relative if it is a temporary buffer. *)
  path   : string;
  (** Any flag that has been passed to the reader in .merlin file *)
  flags  : string list;
  (** Content of the buffer *)
  source : string;
}

(** ASTs exchanged with Merlin *)
type tree =
  | (** An implementation, usually coming from a .ml file *)
    Structure of Parsetree.structure
  | (** An interface, usually coming from a .mli file *)
    Signature of Parsetree.signature
  | (** A type expression, used for instance when printing errors *)
    Type of Parsetree.core_type
    (** FIXME: add more items for completion *)

(** Additional information useful for guiding completion *)
type complete_info = {
  (** True if it is appropriate to suggest labels for this completion. *)
  complete_labels : bool;
}

(** Display a message directly to the user, in the editor. *)
val notify : string -> unit

(** Add a message to merlin log file. *)
val debug : string -> unit
