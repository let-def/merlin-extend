module Description = struct
  type t = Protocol_def.description

  let make_v0 ~name ~version = { Protocol_def. name; version }
end

module Reader = struct
  type t = (module Reader_def.V0)
  let make_v0 (x : (module Reader_def.V0)) : t = x

end

(** The main entry point of an extension should be an instance of this functor.
    No other visible side-effects should occur. *)
let main ?reader desc =
  ()
