module Description : sig
  type t
  val make_v0 : name:string -> version:string -> t
end

module Reader : sig
  type t
  val make_v0 : (module Reader_def.V0) -> t
end

(** The main entry point of an extension should be an instance of this functor.
    No other visible side-effects should occur. *)
val main : ?reader:Reader.t -> Description.t -> unit
