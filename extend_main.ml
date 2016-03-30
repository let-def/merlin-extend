module P = Protocol_def
module Description = struct
  type t = P.description

  let make_v0 ~name ~version = { P. name; version }
end

module Reader = struct
  type t = (module Reader_def.V0)
  let make_v0 (x : (module Reader_def.V0)) : t = x

  module Make (V : Reader_def.V0) = struct

    open P.Reader

    let buffer = ref None

    let get_buffer () =
      match !buffer with
      | None -> invalid_arg "No buffer loaded"
      | Some buffer -> buffer

    let exec = function
      | Load buf ->
        buffer := Some (V.load buf);
        Ret_loaded
      | Parse ->
        Ret_tree (V.tree (get_buffer ()))
      | Parse_line (pos, str) ->
        Ret_tree (V.parse_line (get_buffer ()) pos str)
      | Parse_for_completion pos ->
        let info, tree = V.for_completion (get_buffer ()) pos in
        Ret_tree_for_competion (info, tree)
      | Get_ident_at pos ->
        Ret_ident (V.ident_at (get_buffer ()) pos)
      | Print trees ->
        let buf = get_buffer () in
        let trees = List.rev_map (V.print buf) trees in
        Ret_printed (List.rev trees)
  end
end

module Utils = struct

  (* Postpone messages until ready *)
  let send, set_ready =
    let is_ready = ref false in
    let postponed = ref [] in
    let really_send msg = output_value stdout msg in
    let set_ready () =
      is_ready := true;
      let postponed' = List.rev !postponed in
      postponed := [];
      List.iter really_send postponed'
    in
    let send msg =
      if !is_ready then
        really_send msg
      else
        postponed := msg :: !postponed
    in
    send, set_ready

  let notify msg = send (P.Notify msg)
  let debug msg = send (P.Debug msg)
end

module Handshake = struct
  let magic_number : string = "MERLINEXTEND001"

  type versions = {
    ast_impl_magic_number : string;
    ast_intf_magic_number : string;
    cmi_magic_number : string;
    cmt_magic_number : string;
  }

  let versions = Config.({
      ast_impl_magic_number;
      ast_intf_magic_number;
      cmi_magic_number;
      cmt_magic_number;
    })

 let negotiate (capabilities : P.capabilities) =
    output_string stdout magic_number;
    output_value stdout versions;
    output_value stdout capabilities;
    match input_value stdin with
    | exception End_of_file -> exit 0
    | P.Start_communication -> ()
    | _ ->
      prerr_endline "Unexpected value after handshake.";
      exit 1
end

(** The main entry point of an extension should be an instance of this functor.
    No other visible side-effects should occur. *)

let main ?reader desc =
  (* Check if invoked from Merlin *)
  begin match Sys.getenv "__MERLIN__EXTENSION__" with
  | exception Not_found ->
    Printf.eprintf "This is %s merlin extension, version %s.\n\
                    This binary should be invoked from merlin and \
                    cannot be used directly.\n%!"
      desc.P.name
      desc.P.version;
    exit 1;
  | _ -> ()
  end;
  (* Communication happens on stdin/stdout. *)
  Handshake.negotiate {P. reader = reader <> None};
  let reader = match reader with
    | None -> (fun _ -> failwith "No reader")
    | Some (module R : Reader_def.V0) ->
      let module M = Reader.Make(R) in
      M.exec
  in
  let respond f =
    match f () with
    | (r : P.response) -> Utils.send r
    | exception exn ->
      let name = Printexc.exn_slot_name exn in
      let desc = Printexc.to_string exn in
      Utils.send (P.Exception (name, desc))
  in
  let rec loop () =
    flush stdout;
    match input_value stdin with
    | exception End_of_file -> exit 0
    | P.Start_communication ->
      prerr_endline "Unexpected message.";
      exit 2
    | P.Reader_request request ->
      respond (fun () -> P.Reader_response (reader request));
      loop ()
  in
  loop ()
